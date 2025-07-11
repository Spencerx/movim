<?php

namespace App\Widgets\Syndication;

use App\Post;
use Movim\ImageSize;
use Movim\Widget\Base;

class Syndication extends Base
{
    public function display()
    {
        ob_clean();

        if (!$this->get('s')) {
            return;
        }

        $from = $this->get('s');
        $item = $contact = null;

        $user = \App\User::where('nickname', $from)->first();
        if ($user) {
            $from = $user->id;
        }

        if (filter_var($from, FILTER_VALIDATE_EMAIL)) {
            $node = Post::MICROBLOG_NODE;
            $contact = \App\Contact::firstOrNew(['id' => $from]);
        } elseif (!$this->get('n')) {
            return;
        } else {
            $node = $this->get('n');
            $item = \App\Info::where('server', $from)
                ->where('node', $node)
                ->first();
        }

        $posts = \App\Post::where('server', $from)
            ->where('node', $node)
            ->where('open', true)
            ->orderBy('published', 'desc')
            ->take(20)
            ->get();

        header("Content-Type: application/atom+xml; charset=UTF-8");
        header('Content-Disposition: inline; filename="' . \cleanupId($from . '-' . $node) . '.atom"');

        $dom = new \DOMDocument('1.0', 'UTF-8');
        $dom->formatOutput = true;
        $feed = $dom->createElementNS('http://www.w3.org/2005/Atom', 'feed');
        $dom->appendChild($feed);

        $feed->appendChild($dom->createElement('updated', date('c')));

        $feed->appendChild($self = $dom->createElement('link'));
        $self->setAttribute('rel', 'self');

        $feed->appendChild($alternate = $dom->createElement('link'));
        $alternate->setAttribute('rel', 'alternate');

        if ($contact != null) {
            $feed->appendChild($title = $dom->createElement('title'));
            $title->appendChild($dom->createTextNode(__('feed.title', $contact->truename)));

            $feed->appendChild($author = $dom->createElement('author'));
            $author->appendChild($name = $dom->createElement('name'));
            $name->appendChild($dom->createTextNode($contact->truename));
            $author->appendChild($dom->createElement('uri', $contact->getBlogUrl()));

            if ($contact->getPicture(ImageSize::L)) {
                $logo = $dom->createElement('logo');
                $logo->appendChild($dom->createTextNode($contact->getPicture(ImageSize::L)));
                $feed->appendChild($logo);
            }

            $self->setAttribute('href', $contact->getSyndicationUrl());
            $alternate->setAttribute('href', $contact->getBlogUrl());
        }

        if ($item != null) {
            if ($item->name) {
                $feed->appendChild($title = $dom->createElement('title'));
                $title->appendChild($dom->createTextNode($item->name));
            } else {
                $feed->appendChild($dom->createElement('title', $item->node));
            }

            if ($item->description) {
                $feed->appendChild($subtitle = $dom->createElement('subtitle'));
                $subtitle->appendChild($dom->createTextNode($item->description));
            } else {
                $feed->appendChild($dom->createElement('subtitle', $item->server));
            }

            $self->setAttribute('href', $this->route('feed', [$from, $node]));
            $alternate->setAttribute('href', $this->route('community', [$from, $node]));
        }

        $feed->appendChild($dom->createElement('id', 'xmpp:' . $from . '?;node=' . rawurlencode($node)));

        $feed->appendChild($generator = $dom->createElement('generator', 'Movim'));
        $generator->setAttribute('uri', 'https://movim.eu');
        $generator->setAttribute('version', APP_VERSION);

        foreach ($posts as $post) {
            $feed->appendChild($entry = $dom->createElement('entry'));

            $entry->appendChild($title = $dom->createElement('title'));
            $title->appendChild($dom->createTextNode($post->title));

            $entry->appendChild($dom->createElement('id', $post->getUUID()));
            $entry->appendChild($dom->createElement('updated', date('c', strtotime($post->updated))));

            $f = $dom->createDocumentFragment();

            if ($post->contentcleaned && $f->appendXML($post->contentcleaned)) {
                $entry->appendChild($content = $dom->createElement('content'));
                $content->appendChild($div = $dom->createElementNS('http://www.w3.org/1999/xhtml', 'div'));
                $content->setAttribute('type', 'xhtml');
                $div->appendChild($f);
            }

            foreach ($post->pictures as $value) {
                $entry->appendChild($link = $dom->createElement('link'));
                $link->setAttribute('rel', 'enclosure');
                $link->setAttribute('type', $value->type);
                $link->setAttribute('href', $value->href);
            }

            foreach ($post->links as $value) {
                $entry->appendChild($link = $dom->createElement('link'));
                $link->setAttribute('rel', 'alternate');
                $link->setAttribute('href', (string)$value->href);
            }

            if ($post->openlink) {
                $entry->appendChild($link = $dom->createElement('link'));
                $link->setAttribute('rel', 'alternate');
                $link->setAttribute('type', 'text/html');
                $link->setAttribute('href', $post->openlink->href);
            }
        }

        echo $dom->saveXML();
        exit;
    }
}

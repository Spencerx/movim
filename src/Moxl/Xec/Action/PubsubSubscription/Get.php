<?php

namespace Moxl\Xec\Action\PubsubSubscription;

use Moxl\Xec\Action;
use Moxl\Stanza\Pubsub;
use App\Subscription;

class Get extends Action
{
    protected $_to;
    protected $_pepnode = 'urn:xmpp:pubsub:subscription';

    public function request()
    {
        $this->store();
        Pubsub::getItems($this->_to, $this->_pepnode, 1000);
    }

    public function handle(?\SimpleXMLElement $stanza = null, ?\SimpleXMLElement $parent = null)
    {
        Subscription::where('jid', $this->_to)
                    ->where('public', ($this->_pepnode == 'urn:xmpp:pubsub:subscription'))
                    ->delete();

        $subscriptions = [];

        foreach ($stanza->pubsub->items->children() as $i) {
            $subscription = Subscription::firstOrNew([
                'jid' => $this->_to,
                'server' => (string)$i->subscription->attributes()->server,
                'node' => (string)$i->subscription->attributes()->node
            ]);

            $insertAsWell = false;

            if ($this->_pepnode == 'urn:xmpp:pubsub:subscription') {
                // Remove the private subscriptions to insert the public ones
                if ($subscription->exists && $subscription->public == false) {
                    Subscription::where(function ($query) use ($subscription) {
                        $query->where('jid', $subscription->jid)
                              ->where('server', $subscription->server)
                              ->where('node', $subscription->node);
                    })->delete();

                    $insertAsWell = true;
                }

                $subscription->public = true;
            }

            if (!$subscription->exists || $insertAsWell) {
                array_push($subscriptions, $subscription->toArray());
            }
        }

        Subscription::saveMany($subscriptions);

        $this->pack($this->_to);
        $this->deliver();
    }

    public function errorFeatureNotImplemented($error)
    {
        $this->deliver();
    }

    public function errorItemNotFound($error)
    {
        $this->deliver();
    }
}

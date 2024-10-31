<br />

{autoescape="off"}
    {$c->prepareCard($contact, $roster)}
{/autoescape}

<div class="block">
    <ul class="list middle active divided spaced">
        {if="!$contact->isMe()"}
            {if="$roster && $roster->presences->count() > 0 && !$incall"}
                {loop="$roster->presences"}
                    {if="$value->capability && $value->capability->isJingleAudio()"}
                        <li onclick="Visio_ajaxGetLobby('{$value->jid|echapJS}', true);">
                            <span class="primary icon green">
                                <i class="material-symbols">phone</i>
                            </span>
                            <div>
                                <p class="normal">{$c->__('button.audio_call')}</p>
                            </div>
                        </li>
                    {/if}
                    {if="$value->capability && $value->capability->isJingleVideo()"}
                        <li onclick="Visio_ajaxGetLobby('{$value->jid|echapJS}', true, true);">
                            <span class="primary icon green">
                                <i class="material-symbols">videocam</i>
                            </span>
                            <div>
                                <p class="normal">{$c->__('button.video_call')}</p>
                            </div>
                        </li>
                        {break}
                    {/if}
                {/loop}
            {/if}
            <li onclick="ContactHeader_ajaxChat('{$contact->jid|echapJS}')">
                <span class="primary icon gray">
                    <i class="material-symbols">comment</i>
                </span>
                <div>
                    <p class="normal">
                        {if="isset($message)"}
                            <span class="info" title="{$message->published|prepareDate}">
                                {$message->published|prepareDate:true,true}
                            </span>
                        {/if}
                        {$c->__('button.chat')}
                    </p>
                    {if="isset($message)"}
                        {if="$message->retracted"}
                            <p><i class="material-symbols">delete</i> {$c->__('message.retracted')}</p>
                        {elseif="$message->encrypted"}
                            <p><i class="material-symbols">lock</i> {$c->__('message.encrypted')}</p>
                        {elseif="$message->file"}
                            <p>
                                {if="$message->jidfrom == $message->user_id"}
                                    <span class="moderator">{$c->__('chats.me')}:</span>
                                {/if}
                                {if="$message->file->isPicture"}
                                    <i class="material-symbols">image</i> {$c->__('chats.picture')}
                                {elseif="$message->file->isAudio"}
                                    <i class="material-symbols">equalizer</i> {$c->__('chats.audio')}
                                {elseif="$message->file->isVideo"}
                                    <i class="material-symbols">local_movies</i> {$c->__('chats.video')}
                                {else}
                                    <i class="material-symbols">insert_drive_file</i> {$c->__('avatar.file')}
                                {/if}
                            </p>
                        {elseif="stripTags($message->body) != ''"}
                            <p class="line two">
                                {if="$message->jidfrom == $message->user_id"}
                                    <span class="moderator">{$c->__('chats.me')}:</span>
                                {/if}
                                {autoescape="off"}
                                    {$message->body|stripTags|addEmojis}
                                {/autoescape}
                            </p>
                        {/if}
                    {/if}
                </div>
            </li>
        {/if}
        {if="$roster && !in_array($roster->subscription, ['', 'both'])"}
            <li>
                {if="$roster->subscription == 'to'"}
                    <span class="primary icon gray">
                        <i class="material-symbols">arrow_upward</i>
                    </span>
                    <div>
                        <p>{$c->__('subscription.to')}</p>
                        <p>{$c->__('subscription.to_text')}</p>
                        <p>
                            <button class="button flat" onclick="Notifications_ajaxAddAsk('{$contact->id|echapJS}')">
                                {$c->__('subscription.to_button')}
                            </button>
                        </p>
                    </div>
                {/if}
                {if="$roster->subscription == 'from'"}
                    <span class="primary icon gray">
                        <i class="material-symbols">arrow_downward</i>
                    </span>
                    <div>
                        <p>{$c->__('subscription.from')}</p>
                        <p>{$c->__('subscription.from_text')}</p>
                        <p>
                            <button class="button flat" onclick="Notifications_ajaxAddAsk('{$contact->id|echapJS}')">
                                {$c->__('subscription.from_button')}
                            </button>
                        </p>
                    </div>
                {/if}
                {if="$roster->subscription == 'none'"}
                    <span class="primary icon gray">
                        <i class="material-symbols">block</i>
                    </span>
                    <div>
                        <p>{$c->__('subscription.nil')}</p>
                        <p>{$c->__('subscription.nil_text')}</p>
                        <p>
                            <button class="button flat" onclick="Notifications_ajaxAddAsk('{$contact->id|echapJS}')">
                                {$c->__('subscription.nil_button')}
                            </button>
                        </p>
                    </div>
                {/if}
            </li>
        {/if}
        {if="$contact->isPublic()"}
                <li onclick="MovimUtils.reload('{$contact->getBlogUrl()}')">
                    <span class="primary icon gray">
                        <i class="material-symbols">globe</i>
                    </span>
                    <span class="control icon">
                        <i class="material-symbols">chevron_right</i>
                    </span>
                    <div>
                        <p class="normal">{$c->__('blog.visit')}</p>
                        <p class="line">{$contact->getBlogUrl()}</p>
                    </div>
                </li>
        {/if}
    </ul>
</div>

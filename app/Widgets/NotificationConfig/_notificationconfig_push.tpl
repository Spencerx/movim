{if="$pushSubscriptions->count() > 0"}
<form>
    <div>
        <ul class="list fill thick">
            <li>
                <span class="primary icon gray">
                    <i class="material-symbols">circle_notifications</i>
                </span>
                <div>
                    <p>{$c->__('notificationconfig.push_subscriptions')}</p>
                    <p>{$c->__('notificationconfig.push_subscriptions_text')}</p>
                </div>
            </li>
        </ul>
        <ul class="list fill middle divided">
            {loop="$pushSubscriptions"}
                <li>
                    <span class="primary icon {if="$value->self"}green{else}gray{/if}">
                        <i class="material-symbols">notifications</i>
                    </span>
                    <span class="control">
                        <div class="checkbox">
                            <input
                                type="checkbox"
                                data-identifier="{$value->id}"
                                id="pushsubscription_state_{$value->id}"
                                name="pushsubscription_state_{$value->id}"
                                {if="$value->enabled"}checked{/if}
                                onchange="NotificationConfig_ajaxTogglePushConfig({$value->id}, this.checked)"/>
                            <label for="pushsubscription_state_{$value->id}"></label>
                        </div>
                    </span>
                    <div>
                        <p class="normal">
                            {if="$value->activity_at"}
                                <span class="info">{$c->__('omemo.last_activity')}: {$value->activity_at|prepareDate}</span>
                            {/if}
                            {$value->browser ?? $c->__('notificationconfig.unknown_browser')}
                        </p>
                        <p>{$value->platform ?? $c->__('notificationconfig.unknown_platform')} - {$value->created_at|prepareDate}</p>
                    </div>
                </li>
                {if="$value->self"}{/if}
            {/loop}
        </ul>
    </div>
</form>
{/if}

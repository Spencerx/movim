<section id="location_toggle">
    {if="$contact && $contact->hasLocation()"}
        <div class="placeholder">
            <i class="material-symbols">where_to_vote</i>
        </div>
        <ul class="list">
            <li>
                <span class="control icon active divided" onclick="Location_ajaxClear()">
                    <i class="material-symbols">location_off</i>
                </span>
                <div>
                    <p class="line">{$c->__('location.enabled_title')}</p>
                    <p class="line">
                        {if="$contact->locationUrl"}
                            <a href="{$contact->locationUrl}" target="_blank">
                                {$c->__('location.last_published')}
                            </a>
                        {/if}
                        {if="$contact->loctimestamp"}
                            -
                            {$contact->loctimestamp|prepareDate:true,true}
                        {/if}
                    </p>
                </div>
            </li>
        </ul>
    {else}
        <div class="placeholder">
            <i class="material-symbols">location_off</i>
        </div>
        <ul class="list">
            <li>
                <span class="control icon active divided" onclick="Location.init(); this.classList.add('disabled');">
                    <i class="material-symbols">location_on</i>
                </span>
                <div>
                    <p class="normal all">{$c->__('location.disabled_title')}</p>
                </div>
            </li>
        </ul>
    {/if}
</section>
<footer>
    <button onclick="Dialog_ajaxClear()" class="button flat">
        {$c->__('button.close')}
    </button>
</footer>

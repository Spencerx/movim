<section class="scroll">
    <form name="command" data-sessionid="{$attributes->sessionid}" data-node="{$attributes->node}"  onsubmit="return false;">
        {autoescape="off"}
            {$form}
        {/autoescape}
    </form>
</section>
<footer>
    <button onclick="Dialog_ajaxClear()" class="button flat">
        {$c->__('button.close')}
    </button>

    {if="$status != 'completed'"}
        <button id="adhoc_action" data-jid="{$jid}" onclick="AdHoc.submit(this.dataset.jid)" class="button flat">
            {if="$actions != null"}
                {if="isset($actions->next)"}
                    {$c->__('button.next')}
                {elseif="isset($actions->previous)"}
                    {$c->__('button.previous')}
                {elseif="isset($actions->cancel)"}
                    {$c->__('button.cancel')}
                {elseif="isset($actions->complete)"}
                    {$c->__('button.submit')}
                {/if}
            {else}
                {$c->__('button.submit')}
            {/if}
        </button>
    {/if}
</footer>

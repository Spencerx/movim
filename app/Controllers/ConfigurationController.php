<?php

namespace App\Controllers;

use Movim\Controller\Base;

class ConfigurationController extends Base
{
    public function load()
    {
        $this->session_only = true;
    }

    public function dispatch()
    {
        $this->page->setTitle(__('page.configuration'));
    }
}

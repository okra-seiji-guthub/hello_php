<?php
/**
 * CakePHP(tm) : Rapid Development Framework (https://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (https://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 */

/**
 * Additional bootstrapping and configuration for CLI environments should
 * be put here.
 */

use Cake\Core\Configure;

// Set the fullBaseUrl to allow the generation of links from the CLI.
Configure::write('App.fullBaseUrl', 'http://localhost');

<?php 
/**
 * ownCloud
 *
 * @author Jakob Sack
 * @copyright 2012 Jakob Sack owncloud@jakobsack.de
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU AFFERO GENERAL PUBLIC LICENSE for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

require_once 'lib/base.php';

// The following apps belong to a clean environment:
$allowed_apps = array('calendar', 'contacts', 'files', 'files_sharing', 'files_versions')
// Disable all apps that are not listed here
foreach( getEnabledApps() as $app ){
	if( !in_array( $app, $allowed_apps )){
		OC_App::disable( $app );
	}
}
// Enable all apps that are missing
foreach( $allowed_apps as $app ){
	if( !OC_App::isEnabled( $app  )){
		OC_App::enable( $app );
	}
}

// Delete _all_ users


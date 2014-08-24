<?php
/** 
*
* @package phpBB3
* @version $Id: install.php,v 1.6.8 2008/03/23 14:30:44 rxu Exp $
* @copyright (c) 2005 phpBB Group 
* @license http://opensource.org/licenses/gpl-license.php GNU Public License 
*
*/

/**
* @ignore
*/
define('IN_PHPBB', true);
$phpbb_root_path = './';
$phpEx = substr(strrchr(__FILE__, '.'), 1);
include($phpbb_root_path . 'common.' . $phpEx);

// Start session management
$user->session_begin();
$auth->acl($user->data);
$user->setup();

// Did user forget to login? Give 'em a chance to here ...
if ($user->data['user_id'] == ANONYMOUS)
{
	login_box('', $user->lang['LOGIN_ADMIN'], $user->lang['LOGIN_ADMIN_SUCCESS'], false);
}

// Is user any type of admin? No, then stop here, each script needs to
// check specific permissions but this is a catchall
if (!$auth->acl_get('a_'))
{
	trigger_error('NO_ADMIN');
}

$users = array();

$sql = 'SELECT user_id, username FROM ' . USERS_TABLE;
$result = $db->sql_query($sql);

// Get options values for each user
while ($row = $db->sql_fetchrow($result))
{
	$users[$row['user_id']] = $row['username'];
}
$db->sql_freeresult($result);

foreach ($users as $key => $value)
{
	$username_clean = $db->sql_escape(utf8_clean_string($value));
	echo $username_clean . '<br />';
	$sql = 'UPDATE ' . USERS_TABLE . " SET username_clean = '" . $username_clean . "' WHERE user_id = $key";
	$db->sql_query($sql);
}

trigger_error('INSTALLED');

?>

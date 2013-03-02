default['php']['extra'] = {
	:short_open_tag => 'On',
	:max_execution_time => '60',
	:post_max_size => '50M',
	:upload_max_filesize => '50M',
	:display_errors => 'On',
	:display_startup_errors => 'On',
	:expose_php => 'Off',
}


default['php']['xdebug']['remote_enable'] = 1
default['php']['xdebug']['remote_port'] = 9000
default['php']['xdebug']['remote_connect_back'] = '1'
default['php']['xdebug']['idekey'] = 'XDEBUG_ECLIPSE'
default['php']['xdebug']['profiler_enable_trigger'] = '1'
default['php']['xdebug']['trace_output_dir'] = '/tmp'

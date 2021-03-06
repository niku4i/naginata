module Naginata::Command

  class ExternalCommand

    def self.method_missing(name, *args, &block)
      raise ArgumentError, "only one argment allowed" if args.size > 1
      options = args.first || {}
      dispatch(name, options)
    end

    def self.dispatch(action, options = {})
      action = action.to_s.upcase.to_sym
      raise ArgumentError, "action name #{action} is not implemented" unless List.include? action
      raise ArgumentError, ":path option is required" if options[:path].nil?

      ts = options[:ts] || Time.now.to_i
      format = 'echo "[%d] %s" > %s'
      str = [action.to_s, List.keys_for(action).map{|k| options[k.to_sym]}].flatten.join(';')
      format % [ts, str, options[:path]]
    end

    # ref Original code here
    # https://github.com/ripienaar/ruby-nagios/blob/master/lib/nagios/external_commands/list.rb
    #
    # List of all available nagios external commands, formats and
    # descriptions can be obtained from
    # http://www.nagios.org/developerinfo/externalcommands
    class List
      ACTIONS = {
        :ACKNOWLEDGE_HOST_PROBLEM => %w{host_name sticky notify persistent author comment},
        :ACKNOWLEDGE_SVC_PROBLEM => %w{host_name service_description sticky notify persistent author comment},
        :ADD_HOST_COMMENT => %w{host_name persistent author comment},
        :ADD_SVC_COMMENT => %w{host_name service_description persistent author comment},
        :CHANGE_CONTACT_HOST_NOTIFICATION_TIMEPERIOD => %w{contact_name notification_timeperiod},
        :CHANGE_CONTACT_MODATTR => %w{contact_name value},
        :CHANGE_CONTACT_MODHATTR => %w{contact_name value},
        :CHANGE_CONTACT_MODSATTR => %w{contact_name value},
        :CHANGE_CONTACT_SVC_NOTIFICATION_TIMEPERIOD => %w{contact_name notification_timeperiod},
        :CHANGE_CUSTOM_CONTACT_VAR => %w{contact_name varname varvalue},
        :CHANGE_CUSTOM_HOST_VAR => %w{host_name varname varvalue},
        :CHANGE_CUSTOM_SVC_VAR => %w{host_name service_description varname varvalue},
        :CHANGE_GLOBAL_HOST_EVENT_HANDLER => %w{event_handler_command},
        :CHANGE_GLOBAL_SVC_EVENT_HANDLER => %w{event_handler_command},
        :CHANGE_HOST_CHECK_COMMAND => %w{host_name check_command},
        :CHANGE_HOST_CHECK_TIMEPERIOD => %w{host_name check_timeperod},
        :CHANGE_HOST_EVENT_HANDLER => %w{host_name event_handler_command},
        :CHANGE_HOST_MODATTR => %w{host_name value},
        :CHANGE_MAX_HOST_CHECK_ATTEMPTS => %w{host_name check_attempts},
        :CHANGE_MAX_SVC_CHECK_ATTEMPTS => %w{host_name service_description check_attempts},
        :CHANGE_NORMAL_HOST_CHECK_INTERVAL => %w{host_name check_interval},
        :CHANGE_NORMAL_SVC_CHECK_INTERVAL => %w{host_name service_description check_interval},
        :CHANGE_RETRY_HOST_CHECK_INTERVAL => %w{host_name service_description check_interval},
        :CHANGE_RETRY_SVC_CHECK_INTERVAL => %w{host_name service_description check_interval},
        :CHANGE_SVC_CHECK_COMMAND => %w{host_name service_description check_command},
        :CHANGE_SVC_CHECK_TIMEPERIOD => %w{host_name service_description check_timeperiod},
        :CHANGE_SVC_EVENT_HANDLER => %w{host_name service_description event_handler_command},
        :CHANGE_SVC_MODATTR => %w{host_name service_description value},
        :CHANGE_SVC_NOTIFICATION_TIMEPERIOD => %w{host_name service_description notification_timeperiod},
        :DELAY_HOST_NOTIFICATION => %w{host_name notification_time},
        :DELAY_SVC_NOTIFICATION => %w{host_name service_description notification_time},
        :DEL_ALL_HOST_COMMENTS => %w{host_name},
        :DEL_ALL_SVC_COMMENTS => %w{host_name service_description},
        :DEL_HOST_COMMENT => %w{comment_id},
        :DEL_HOST_DOWNTIME => %w{downtime_id},
        :DEL_SVC_COMMENT => %w{comment_id},
        :DEL_SVC_DOWNTIME => %w{downtime_id},
        :DISABLE_ALL_NOTIFICATIONS_BEYOND_HOST => %w{host_name},
        :DISABLE_CONTACTGROUP_HOST_NOTIFICATIONS => %w{contactgroup_name},
        :DISABLE_CONTACTGROUP_SVC_NOTIFICATIONS => %w{contactgroup_name},
        :DISABLE_CONTACT_HOST_NOTIFICATIONS => %w{contact_name},
        :DISABLE_CONTACT_SVC_NOTIFICATIONS => %w{contact_name},
        :DISABLE_EVENT_HANDLERS => [],
        :DISABLE_FAILURE_PREDICTION => [],
        :DISABLE_FLAP_DETECTION => [],
        :DISABLE_HOSTGROUP_HOST_CHECKS => %w{hostgroup_name},
        :DISABLE_HOSTGROUP_HOST_NOTIFICATIONS => %w{hostgroup_name},
        :DISABLE_HOSTGROUP_PASSIVE_HOST_CHECKS => %w{hostgroup_name},
        :DISABLE_HOSTGROUP_PASSIVE_SVC_CHECKS => %w{hostgroup_name},
        :DISABLE_HOSTGROUP_SVC_CHECKS => %w{hostgroup_name},
        :DISABLE_HOSTGROUP_SVC_NOTIFICATIONS => %w{hostgroup_name},
        :DISABLE_HOST_AND_CHILD_NOTIFICATIONS => %w{host_name},
        :DISABLE_HOST_CHECK => %w{host_name},
        :DISABLE_HOST_EVENT_HANDLER => %w{host_name},
        :DISABLE_HOST_FLAP_DETECTION => %w{host_name},
        :DISABLE_HOST_FRESHNESS_CHECKS => [],
        :DISABLE_HOST_NOTIFICATIONS => %w{host_name},
        :DISABLE_HOST_SVC_CHECKS => %w{host_name},
        :DISABLE_HOST_SVC_NOTIFICATIONS => %w{host_name},
        :DISABLE_NOTIFICATIONS => [],
        :DISABLE_PASSIVE_HOST_CHECKS => %w{host_name},
        :DISABLE_PASSIVE_SVC_CHECKS => %w{host_name service_description},
        :DISABLE_PERFORMANCE_DATA => [],
        :DISABLE_SERVICEGROUP_HOST_CHECKS => %w{servicegroup_name},
        :DISABLE_SERVICEGROUP_HOST_NOTIFICATIONS => %w{servicegroup_name},
        :DISABLE_SERVICEGROUP_PASSIVE_HOST_CHECKS => %w{servicegroup_name},
        :DISABLE_SERVICEGROUP_PASSIVE_SVC_CHECKS => %w{servicegroup_name},
        :DISABLE_SERVICEGROUP_SVC_CHECKS => %w{servicegroup_name},
        :DISABLE_SERVICEGROUP_SVC_NOTIFICATIONS => %w{servicegroup_name},
        :DISABLE_SERVICE_FLAP_DETECTION => %w{host_name service_description},
        :DISABLE_SERVICE_FRESHNESS_CHECKS => [],
        :DISABLE_SVC_CHECK => %w{host_name service_description},
        :DISABLE_SVC_EVENT_HANDLER => %w{host_name service_description},
        :DISABLE_SVC_FLAP_DETECTION => %w{host_name service_description},
        :DISABLE_SVC_NOTIFICATIONS => %w{host_name service_description},
        :ENABLE_ALL_NOTIFICATIONS_BEYOND_HOST => %w{host_name},
        :ENABLE_CONTACTGROUP_HOST_NOTIFICATIONS => %w{contactgroup_name},
        :ENABLE_CONTACTGROUP_SVC_NOTIFICATIONS => %w{contactgroup_name},
        :ENABLE_CONTACT_HOST_NOTIFICATIONS => %w{contact_name},
        :ENABLE_CONTACT_SVC_NOTIFICATIONS => %w{contact_name},
        :ENABLE_EVENT_HANDLERS => [],
        :ENABLE_FAILURE_PREDICTION => [],
        :ENABLE_FLAP_DETECTION => [],
        :ENABLE_HOSTGROUP_HOST_CHECKS => %w{hostgroup_name},
        :ENABLE_HOSTGROUP_HOST_NOTIFICATIONS => %w{hostgroup_name},
        :ENABLE_HOSTGROUP_PASSIVE_HOST_CHECKS => %w{hostgroup_name},
        :ENABLE_HOSTGROUP_PASSIVE_SVC_CHECKS => %w{hostgroup_name},
        :ENABLE_HOSTGROUP_SVC_CHECKS => %w{hostgroup_name},
        :ENABLE_HOSTGROUP_SVC_NOTIFICATIONS => %w{hostgroup_name},
        :ENABLE_HOST_AND_CHILD_NOTIFICATIONS => %w{host_name},
        :ENABLE_HOST_CHECK => %w{host_name},
        :ENABLE_HOST_EVENT_HANDLER => %w{host_name},
        :ENABLE_HOST_FLAP_DETECTION => %w{host_name},
        :ENABLE_HOST_FRESHNESS_CHECKS => [],
        :ENABLE_HOST_NOTIFICATIONS => %w{host_name},
        :ENABLE_HOST_SVC_CHECKS => %w{host_name},
        :ENABLE_HOST_SVC_NOTIFICATIONS => %w{host_name},
        :ENABLE_NOTIFICATIONS => [],
        :ENABLE_PASSIVE_HOST_CHECKS => %w{host_name},
        :ENABLE_PASSIVE_SVC_CHECKS => %w{host_name service_description},
        :ENABLE_PERFORMANCE_DATA => [],
        :ENABLE_SERVICEGROUP_HOST_CHECKS => %w{servicegroup_name},
        :ENABLE_SERVICEGROUP_HOST_NOTIFICATIONS => %w{servicegroup_name},
        :ENABLE_SERVICEGROUP_PASSIVE_HOST_CHECKS => %w{servicegroup_name},
        :ENABLE_SERVICEGROUP_PASSIVE_SVC_CHECKS => %w{servicegroup_name},
        :ENABLE_SERVICEGROUP_SVC_CHECKS => %w{servicegroup_name},
        :ENABLE_SERVICEGROUP_SVC_NOTIFICATIONS => %w{servicegroup_name},
        :ENABLE_SERVICE_FRESHNESS_CHECKS => [],
        :ENABLE_SVC_CHECK => %w{host_name service_description},
        :ENABLE_SVC_EVENT_HANDLER => %w{host_name service_description},
        :ENABLE_SVC_FLAP_DETECTION => %w{host_name service_description},
        :ENABLE_SVC_NOTIFICATIONS => %w{host_name service_description},
        :PROCESS_FILE => %w{file_name delete},
        :PROCESS_HOST_CHECK_RESULT => %w{host_name status_code plugin_output},
        :PROCESS_SERVICE_CHECK_RESULT => %w{host_name service_description return_code plugin_output},
        :READ_STATE_INFORMATION => [],
        :REMOVE_HOST_ACKNOWLEDGEMENT => %w{host_name},
        :REMOVE_SVC_ACKNOWLEDGEMENT => %w{host_name service_description},
        :RESTART_PROGRAM => [],
        :SAVE_STATE_INFORMATION => [],
        :SCHEDULE_AND_PROPAGATE_HOST_DOWNTIME => %w{host_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_AND_PROPAGATE_TRIGGERED_HOST_DOWNTIME => %w{host_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_FORCED_HOST_CHECK => %w{host_name check_time},
        :SCHEDULE_FORCED_HOST_SVC_CHECKS => %w{host_name check_time},
        :SCHEDULE_FORCED_SVC_CHECK => %w{host_name service_description check_time},
        :SCHEDULE_HOSTGROUP_HOST_DOWNTIME => %w{hostgroup_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_HOSTGROUP_SVC_DOWNTIME => %w{hostgroup_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_HOST_CHECK => %w{host_name check_time},
        :SCHEDULE_HOST_DOWNTIME => %w{host_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_HOST_SVC_CHECKS => %w{host_name check_time},
        :SCHEDULE_HOST_SVC_DOWNTIME => %w{host_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_SERVICEGROUP_HOST_DOWNTIME => %w{servicegroup_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_SERVICEGROUP_SVC_DOWNTIME => %w{servicegroup_name start_time end_time fixed trigger_id duration author comment},
        :SCHEDULE_SVC_CHECK => %w{host_name service_description check_time},
        :SCHEDULE_SVC_DOWNTIME => %w{host_name service_desription start_time end_time fixed trigger_id duration author comment},
        :SEND_CUSTOM_HOST_NOTIFICATION => %w{host_name options author comment},
        :SEND_CUSTOM_SVC_NOTIFICATION => %w{host_name service_description options author comment},
        :SET_HOST_NOTIFICATION_NUMBER => %w{host_name notification_number},
        :SET_SVC_NOTIFICATION_NUMBER => %w{host_name service_description notification_number},
        :SHUTDOWN_PROGRAM => [],
        :START_ACCEPTING_PASSIVE_HOST_CHECKS => [],
        :START_ACCEPTING_PASSIVE_SVC_CHECKS => [],
        :START_EXECUTING_HOST_CHECKS => [],
        :START_EXECUTING_SVC_CHECKS => [],
        :START_OBSESSING_OVER_HOST => %w{host_name},
        :START_OBSESSING_OVER_HOST_CHECKS => [],
        :START_OBSESSING_OVER_SVC => %w{host_name service_description},
        :START_OBSESSING_OVER_SVC_CHECKS => [],
        :STOP_ACCEPTING_PASSIVE_HOST_CHECKS => [],
        :STOP_ACCEPTING_PASSIVE_SVC_CHECKS => [],
        :STOP_EXECUTING_HOST_CHECKS => [],
        :STOP_EXECUTING_SVC_CHECKS => [],
        :STOP_OBSESSING_OVER_HOST => %w{host_name},
        :STOP_OBSESSING_OVER_HOST_CHECKS => [],
        :STOP_OBSESSING_OVER_SVC => %w{host_name service_description},
        :STOP_OBSESSING_OVER_SVC_CHECKS => []
      }.freeze

      def self.include?(action)
        ACTIONS.keys.include? action.to_sym
      end

      def self.keys_for(action)
        ACTIONS[action]
      end
    end

  end
end

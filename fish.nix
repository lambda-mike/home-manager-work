{
  enable = true;
  functions = {
    fish_mode_prompt = ''
      echo -s '['
      switch $fish_bind_mode
        case default
          set_color --bold green
          echo -s 'N'
        case insert
          set_color --bold blue
          echo -s 'I'
        case replace_one
          set_color --bold red
          echo -s 'R'
        case visual
          set_color --bold brmagenta
          echo -s 'V'
        case '*'
          set_color --bold red
          echo -s '?'
      end
      set_color normal
      echo -s ']'
    '';
    fish_right_prompt = ''
      function _colour_normal
          set_color -o normal
      end

      function _colour_err
          set_color -o d30102
      end

      function _colour_main
          set_color -o 005fd7
      end

      function _colour_ok
          set_color -o brgreen
      end

      function __cmd_duration -d 'Displays the elapsed time of last command'
          set -l last_status $status
          set -l seconds ""
          set -l minutes ""
          set -l hours ""
          set -l days ""
          set -l cmd_duration (expr $CMD_DURATION / 1000)
          if test $cmd_duration -ge 0
              set seconds (expr $cmd_duration \% 68400 \% 3600 \% 60)'s'
              if test $cmd_duration -ge 60
                  set minutes (expr $cmd_duration \% 68400 \% 3600 / 60)'m'
                  if test $cmd_duration -gt 3600
                      set hours (expr $cmd_duration \% 68400 / 3600)'h'
                      if test $cmd_duration > 68400
                          set days (expr $cmd_duration / 68400)'d'
                      end
                  end
              end
              if test $last_status -ne 0
                echo -n (_colour_main)' ❮ '
                _colour_err
                echo -n $last_status
                echo -n (_colour_main)' ❮❮'
                _colour_err
                echo -n ' '$days$hours$minutes$seconds
              else
                  echo -n -s (_colour_main) '❮'
                  _colour_ok
                  echo -n ' '$days$hours$minutes$seconds
              end
              echo -n (_colour_main)' ❮'(_colour_normal)
          end
      end

      function __current_time -d 'Displays current time'
        echo -n (_colour_main)'❮ '(_colour_normal)
        echo -n (date +%H(_colour_main):(_colour_normal)%M(_colour_main):(_colour_normal)%S)
        echo -n (_colour_main)' ❮'(_colour_normal)
      end

      echo -n -s (__cmd_duration) (__current_time)
      _colour_normal
    '';
  };
  shellInit = ''
    set -g -x fish_greeting 'Let the λ force be with you! :-)'
    set -g -x fish_key_bindings fish_vi_key_bindings
    set -g -x BROWSER /usr/bin/firefox
'';
}

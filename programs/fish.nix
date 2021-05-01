{ config, lib, pkgs, ... }:

{
  programs = {
    fish = {
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
        fish_prompt = ''
# name: Classic + Vcs (the default)
# author: Lily Ballard
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix 'λ'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    # Write pipestatus
    # If the status was carried over (e.g. after `set`), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color $bold_flag $fish_color_status) $last_pipestatus)

    set -g __fish_git_prompt_show_informative_status
    set -g __fish_git_prompt_showcolorhints
    set -g __fish_git_prompt_showdirtystate
    set -g __fish_git_prompt_showuntrackedfiles
    set -g __fish_git_prompt_showupstream

    set -l nix_shell_info (
        if test -n "$IN_NIX_SHELL"
            set_color yellow
            echo -n " <nix-shell>"
            set_color normal
        end
    )

    echo -s (set_color $fish_color_user) " $USER" $normal @ (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_git_prompt) $nix_shell_info $normal " "$prompt_status " "
    echo -n -s (set_color blue) "(" (set_color brgreen) $suffix (set_color blue) ") "
set_color normal
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
    set -g -x BROWSER brave
    set -g -x SHELL /home/mike/.nix-profile/bin/fish
    set -g -x NNN_BMS 'c:~/Documents/Documents/coding;l:~/linux-config/'
    set -g -x NNN_COLORS '#283fe21b;2341'
    set -g -x NNN_OPTS 'd'
    set -g -x NNN_PLUG 'b:-_bat $nnn;c:-_copy-to-clip $nnn*;e:_emacs $nnn*;f:-_feh $nnn*;g:_|gimp $nnn;i:-_viu $nnn;k:_kak $nnn*;v:_|vlc $nnn;z:_|zathura $nnn'
'';
    };
  };
}

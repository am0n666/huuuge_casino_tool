_hcgu()
{
    local cur prev words cword
    _init_completion || return

    local COMMANDS=(
        "main_menu"
        "restore_dialog"
        "backup_cp_n_clean"
        "start_game"
        "kill_game"
        "clean_profile"
        "backup_hc_data"
        "restore_hc_data"
        "restore_next"
        "restore_from_path"
        "backup_next"
        "update_backup"
        "setup_completion"
        )
 
    local command i
    for (( i=0; i < ${#words[@]}-1; i++ )); do
        if [[ ${COMMANDS[@]} =~ ${words[i]} ]]; then
            command=${words[i]}
            break
        fi
    done


   COMPREPLY=( $( compgen -W '${COMMANDS[@]}' -- "$cur" ) )
}
complete -F _hcgu hcgu

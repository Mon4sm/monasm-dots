#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <dirent.h>
#include <sys/stat.h>

#define size(x) sizeof(x)/sizeof(x[0])

char git_path[] = "https://github.com/Mon4sm/monasm-dots";
char *dependency[] = {"awk","basename","bash","brightnessctl","cat","cp","curl","cut","date","echo","eww","fastfetch","fc-cache","fc-list","git","grep","grim","head","hyprctl","hypridle","hyprland","hyprlock","hyprpaper","jq","kitty","loginctl","ls","mkdir","mv","nmcli","nvim","pamixer","pidof","playerctl","ranger","rm","sh","sleep","slurp","socat","stdbuf","systemctl","uptime","wget","wpctl","xargs"};
char *font_dependency[] = {"JetBrainsMono Nerd Font"};
char *exe_file[] = {"batest.sh","getvol.sh","menu.sh","wifictl.sh","batico.sh","current-wifi.sh","kb-delay.sh","music.sh","wifi-delay.sh","battery.sh","get_kb.sh","lock.sh","pmusic.sh","workspace.sh","calendar.sh","getnet.sh","menuctl.sh","usrctl.sh","wifi-disconnect.sh","coretemp.sh"};
char *hypr_file[] = {"/delay-exec.sh","/battery.sh","/kb-switch.sh","/set-eww-vars.sh","/text_animation/anitext.sh","/weather/weather.sh"};
char *hypr_name[] = {"delay-exec.sh","battery.sh","kb-switch.sh","set-eww-vars.sh","anitext.sh","weather.sh"};

void boot(){
    printf("\033[93mStarting monasm-dots installation script");
    fflush(stdout);
    sleep(1);
    for(int i=0;i<3;i++){
        printf(".");
        fflush(stdout);
        sleep(1);
    }
    printf("\033[0m\n");
}

void dependencies(){
    printf("\033[93mChecking dependencies...\033[0m\n");
    int cnt=0;
    for(int i=0;i<size(dependency);i++){
        char cmd[256],path[1024];
        FILE *pipe;
        snprintf(cmd,sizeof(cmd),"which %s 2>/dev/null",dependency[i]);
        pipe = popen(cmd,"r");
        printf("Finding Dependency: %s\n",dependency[i]);
        usleep(100000);
        if(fgets(path,sizeof(path),pipe)!=NULL){
            path[strcspn(path,"\n")]=0;
            printf("    \033[92mFound: %s at %s\033[0m\n",dependency[i],path);
        }
        else{
            sleep(1);
            printf("    \033[31mMissing dependency: %s\033[0m\n",dependency[i]);
            cnt++;
        }
        pclose(pipe);
    }
    for(int i=0;i<size(font_dependency);i++){
        char cmd[256];
        FILE *pipe;
        snprintf(cmd,sizeof(cmd),"fc-list | grep -qi \"%s\"",font_dependency[i]);
        printf("Finding Dependency: %s\n",font_dependency[i]);
        usleep(100000);
        if(system(cmd)==0){
            printf("    \033[92mFound: %s\033[0m\n",font_dependency[i]);
        }
        else{
            sleep(1);
            printf("    \033[31mMissing dependency: %s\033[0m\n",font_dependency[i]);
            cnt++;
        }
    }
    if(cnt){
        printf("\033[31mRequirements unfulfilled. Missing dependencies (%d/%d). Ending process...\033[0m\n",cnt,size(dependency)+size(font_dependency));
        exit(EXIT_FAILURE);
    }
}

void clone(){
    if(!access("monasm-dots",F_OK)){
        system("rm -rf monasm-dots");
    }
    char cmd[128];
    snprintf(cmd,sizeof(cmd),"git clone %s",git_path);
    int status = system(cmd);
    if(status){
        printf("\033[31m\nFailed to clone repository from: %s\nEnding process...\033[0m\n",git_path);
        exit(EXIT_FAILURE);
    }
    else{
        printf("\033[92m\nSuccessfully cloned repository from: %s\033[0m\n",git_path);
    }
}

void warning(){
    char c;
    printf("\033[93mWARNING!!! The next procedure will overwrite **crucial Hyprland configuration files**.\nTo see which folders will be replaced, check out this repository:\n	%s\nAll the folders in the .config folder of this repository will be replacing all folders in your ~/.config directory. Before continuing, make sure to save any important files!\n\033[0m",git_path);
    while(!(c=='Y'||c=='y'||c=='N'||c=='n')){
        printf("\033[93mDo you wish to proceed (Y/N): \033[0m");
        scanf(" %c",&c);
        if((c=='Y'||c=='y'||c=='N'||c=='n')){
            break;
        }
        else{
            printf("\033[31mIncorrect input!\n\033[0m");
	    }
    }
    if(c=='N'||c=='n'){
	    printf("\033[92mEnding process...\033[0m\n");
	    exit(EXIT_SUCCESS);
    }
}

void privilege_esc(){
    printf("\n");
    for(int i=0;i<size(exe_file);i++){
        char path[256];
        printf("Escalating program privilege: %s\n",exe_file[i]);
        snprintf(path,sizeof(path),"./monasm-dots/.config/eww/scripts/%s",exe_file[i]);
        if(chmod(path,0755)!=0){
            printf("\033[31m    Failed to set %s to executable!\n\033[0m\n",exe_file[i]);
        }
        else{
            printf("\033[92m    Successfully set %s to executable!\033[0m\n",exe_file[i]);
        }
    }
    for(int i=0;i<size(hypr_file);i++){
        char path[256];
        printf("Escalating program privilege: %s\n",hypr_name[i]);
        snprintf(path,sizeof(path),"./monasm-dots/.config/hypr/scripts/%s",hypr_file[i]);
        if(chmod(path,0755)!=0){
            printf("\033[31m    Failed to set %s to executable!\n\033[0m\n",hypr_name[i]);
        }
        else{
            printf("\033[92m    Successfully set %s to executable!\033[0m\n",hypr_name[i]);
        }
    }
}

void install_configs(){
    char *home = getenv("HOME");
    if(home==NULL){
        printf("\033[31mCould not resolve $HOME. Ending process...\033[0m\n");
        exit(EXIT_FAILURE);
    }
    printf("\n\033[93mInstalling configuration files...\033[0m\n");

    DIR *d = opendir("./monasm-dots/.config");
    if(d==NULL){
        printf("\033[31mCould not open cloned .config directory. Ending process...\033[0m\n");
        exit(EXIT_FAILURE);
    }

    char config_dir[512],backup_dir[512],cmd[2048];
    snprintf(config_dir,sizeof(config_dir),"%s/.config",home);
    snprintf(backup_dir,sizeof(backup_dir),"%s/.rice-backup-%ld",home,(long)time(NULL));
    snprintf(cmd,sizeof(cmd),"mkdir -p \"%s\"",config_dir);
    system(cmd);

    int backed_up = 0;
    struct dirent *e;
    while((e=readdir(d))!=NULL){
        if(strcmp(e->d_name,".")==0 || strcmp(e->d_name,"..")==0){
            continue;
        }
        char target[1024];
        snprintf(target,sizeof(target),"%s/.config/%s",home,e->d_name);
        if(!access(target,F_OK)){
            if(!backed_up){
                snprintf(cmd,sizeof(cmd),"mkdir -p \"%s\"",backup_dir);
                system(cmd);
                backed_up = 1;
                printf("\033[93mBacking up existing configs to %s\033[0m\n",backup_dir);
            }
            snprintf(cmd,sizeof(cmd),"mv \"%s\" \"%s/\"",target,backup_dir);
            system(cmd);
            printf("    \033[93mBacked up: %s\033[0m\n",e->d_name);
        }
        snprintf(cmd,sizeof(cmd),"cp -r \"./monasm-dots/.config/%s\" \"%s/.config/\"",e->d_name,home);
        if(system(cmd)){
            printf("    \033[31mFailed to install: %s\033[0m\n",e->d_name);
        }
        else{
            printf("    \033[92mInstalled: %s\033[0m\n",e->d_name);
        }
    }
    closedir(d);
}

void install_fonts(){
    char *home = getenv("HOME");
    printf("\n\033[93mInstalling fonts...\033[0m\n");

    char font_dir[512],cmd[2048];
    snprintf(font_dir,sizeof(font_dir),"%s/.local/share/fonts",home);
    snprintf(cmd,sizeof(cmd),"mkdir -p \"%s\"",font_dir);
    system(cmd);

    snprintf(cmd,sizeof(cmd),"cp -r ./monasm-dots/font/. \"%s/\"",font_dir);
    if(system(cmd)){
        printf("    \033[31mFailed to copy fonts.\033[0m\n");
    }
    else{
        printf("    \033[92mCopied bundled fonts to %s\033[0m\n",font_dir);
    }
    system("fc-cache -f >/dev/null 2>&1");
    printf("    \033[92mRefreshed font cache.\033[0m\n");
    printf("\033[93m    Note: this rice also uses \"JetBrainsMono Nerd Font\", which is not bundled.\n    Install it with: sudo pacman -S ttf-jetbrains-mono-nerd\033[0m\n");
}

void finish(){
    printf("\n\033[92mmonasm-dots installed successfully!\033[0m\n");
    printf("\033[93mLog out and back into Hyprland, or run 'hyprctl reload', to apply the new configuration.\033[0m\n");
}

int main(){
    setenv("PATH","/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin",1);
    boot();
    dependencies();
    clone();
    warning();
    privilege_esc();
    install_configs();
    install_fonts();
    finish();
}

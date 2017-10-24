#include <stdio.h>
#include <stdlib.h>
#include <sys/inotify.h>
#include <unistd.h>
#include <vector>
#include <string>
#include <iostream>

using namespace std;


int main(void){
	int fd = 0;  
    char data[255] = {0};  
    int readLength = 0;  
    char* eventptr;
    int step = 0;
    struct inotify_event event;

    fd = inotify_init1(IN_NONBLOCK);
    inotify_add_watch(fd, ".",IN_CREATE|IN_MOVED_TO|IN_DELETE);//监听文件是否打开  
    while(1)
    {
        readLength = read(fd, data, 255);//没打开，那么就会阻塞 
        if(readLength > 0)
        {
            // cout <<  readLength << endl;
            eventptr = data;
            event.wd = *((int*)eventptr);
            step +=sizeof(int);
            //eventptr += sizeof(int);
            event.mask = *((uint32_t*)(eventptr+step));
            step  += sizeof(uint32_t);
            event.cookie  = *((uint32_t*)(eventptr+step));
            step += sizeof(uint32_t);
            event.len  = *((uint32_t*)(eventptr+step));
            step += sizeof(uint32_t);
            string filename(eventptr+step);
            step = 0;

            // cout << "wd:"<<event.wd << endl;
            // cout << "mask:"<<event.mask << endl;
            // cout << "cookie:"<<event.cookie  << endl;
            // cout << "len:" <<event.len<< endl;
            // cout << "filename:" <<filename << endl;
            // cout << filename.size() << endl
            if(event.mask == IN_CREATE)
            {
                cout <<"new file was created:"<< filename << endl;//如果打开，那么会继续跑到这里
            } 
            else if(event.mask == IN_MOVED_TO)
            {
                cout <<"new file was move to mydir:"<< filename<< endl;//如果打开，那么会继续跑到这里 
          
            }
            else if(event.mask == IN_DELETE)
            {
                cout <<"file was remove:"<< filename << endl;//如果打开，那么会继续跑到这里 
            }
        } 
        sleep(1);
    }
    
}
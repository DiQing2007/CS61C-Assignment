#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *tortoise = head;
    node *hare = head == NULL ? NULL : head ->next;
    while(1){
        if(hare){
            hare = hare->next;
            if(hare){
                 hare = hare->next;
                if(hare){
                    tortoise = tortoise->next;
                    if(tortoise == hare){
                        return 1;
                    }
                    else{
                        continue;
                    }
                }
                else{
                    break;
                }
            }
            else{
                break;
            }
        }
        else{
            break;
        }
    }
    
    return 0;
}
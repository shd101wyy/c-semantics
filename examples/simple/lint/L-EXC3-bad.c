#include <stdlib.h>
#include <stdio.h>

void func(int number)
{
    printf("func called with number: %i\n", number);
}

int main()
{
    void (*func_ptr)(int) = &func;
    if(func_ptr != ((void *) NULL))
    {
        func(1);
        
    }
    
}

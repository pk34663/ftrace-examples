Example of tracing syscalls using the ftrace framework for example:

# trace_syscall.sh -t10 sys_setpriority
Timer...10
Starting trace
enabling sys_enter_setpriority
Stopping tracing
# tracer: nop
#
# entries-in-buffer/entries-written: 2/2   #P:2
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
           a.out-10922 [001] .... 51317.532735: sys_setpriority(which: 0, who: 2aa2, niceval: 6)
           a.out-10923 [000] .... 51320.330287: sys_setpriority(which: 0, who: 2aa2, niceval: 6)

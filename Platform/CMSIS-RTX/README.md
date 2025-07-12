# CMSIS RTX Zig Wrapper

This is a wrapper to use [CMSIS RTX5](https://github.com/ARM-software/CMSIS-RTX) in embedded Zig projects.

This component implements access to the [CMSIS-RTOS2](https://arm-software.github.io/CMSIS_6/latest/RTOS2/index.html) APIs, so it could be modified to use other RTOS kernels that have corresponding CMSIS-RTOS2 facades/skins.

## Disclaimers

This project is not affiliated with the Rust Foundation or the Rust Project.

## License

See [LICENSE](LICENSE) file for more information

## Supported RTOS Components

- **Kernel**: Initialization and control
- **Threads**: Static and dynamic thread creation with priority control
- **Timers**: One-shot and periodic timers with callbacks
- **Mutexes**: Mutual exclusion with priority inheritance support
- **Semaphores**: Counting semaphores for resource management
- **Event Flags**: Synchronization using flag bits
- **Message Queues**: Type-safe inter-thread communication
- **Delays**: Time-based delays and scheduling

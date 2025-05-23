// Tests CUDA compilation with -S and -emit-llvm.

// RUN: %clang -### -S --target=x86_64-linux-gnu --cuda-gpu-arch=sm_20 --cuda-path=%S/Inputs/CUDA_80/usr/local/cuda %s 2>&1 \
// RUN:   | FileCheck -check-prefix HOST -check-prefix SM20 %s
// RUN: %clang -### -S --target=x86_64-linux-gnu --cuda-host-only -o foo.s --cuda-path=%S/Inputs/CUDA_80/usr/local/cuda %s 2>&1 \
// RUN:   | FileCheck -check-prefix HOST %s
// RUN: %clang -### -S --target=x86_64-linux-gnu --cuda-gpu-arch=sm_20 \
// RUN:   --cuda-device-only -o foo.s --cuda-path=%S/Inputs/CUDA_80/usr/local/cuda %s 2>&1 \
// RUN:   | FileCheck -check-prefix SM20 %s
// RUN: %clang -### -S --target=x86_64-linux-gnu --cuda-gpu-arch=sm_20 \
// RUN:   --cuda-gpu-arch=sm_30 --cuda-device-only --cuda-path=%S/Inputs/CUDA_80/usr/local/cuda %s 2>&1 \
// RUN:   | FileCheck -check-prefix SM20 -check-prefix SM30 %s

// HOST-DAG: "-cc1" "-triple" "x86_64-unknown-linux-gnu"
// SM20-DAG: "-cc1" "-triple" "nvptx64-nvidia-cuda"
// SM20-same: "-target-cpu" "sm_20"
// SM30-DAG: "-cc1" "-triple" "nvptx64-nvidia-cuda"
// SM30-same: "-target-cpu" "sm_30"

// RUN: not %clang -### -S --target=x86_64-linux-gnu --cuda-device-only \
// RUN:   --cuda-gpu-arch=sm_20 --cuda-gpu-arch=sm_30 -o foo.s %s 2>&1 \
// RUN:   | FileCheck -check-prefix MULTIPLE-OUTPUT-FILES %s
// MULTIPLE-OUTPUT-FILES: error: cannot specify -o when generating multiple output files
// Make sure we do not get duplicate diagnostics.
// MULTIPLE-OUTPUT-FILES-NOT: error: cannot specify -o when generating multiple output files

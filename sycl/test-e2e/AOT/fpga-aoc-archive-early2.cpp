// Test compiler behaviors for -fintelfpga with -fsycl-link=early.

// REQUIRES: opencl-aot, accelerator

// Remove any archives
// RUN: rm -f %t_*.a

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// RUN: %clangxx -fintelfpga -fsycl %S/Inputs/fpga_main.cpp -c -o %t_main.o

// Build any early archive binaries.
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=early %S/Inputs/fpga_sub.cpp   -o %t_early_sub.a
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=early %S/Inputs/fpga_add.cpp   -o %t_early_add.a
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=early %S/Inputs/fpga_sub_x.cpp -o %t_early_sub_x.a
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=early %S/Inputs/fpga_add_x.cpp -o %t_early_add_x.a

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Build any image archive binaries from early archives.
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=image -Wno-unused-command-line-argument %t_early_sub.a   -o %t_early_image_sub.a
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=image -Wno-unused-command-line-argument %t_early_add.a   -o %t_early_image_add.a
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=image -Wno-unused-command-line-argument %t_early_sub_x.a -o %t_early_image_sub_x.a
// RUN: %clangxx -fintelfpga -fsycl -fsycl-link=image -Wno-unused-command-line-argument %t_early_add_x.a -o %t_early_image_add_x.a
////////////////////////////////////////////////////////////////////////////////
// Use a variety of archive orders
////////////////////////////////////////////////////////////////////////////////
// RUN: %clangxx -fintelfpga -fsycl %t_main.o %t_early_image_add.a %t_early_image_sub.a %t_early_image_add_x.a %t_early_image_sub_x.a -o %t_early_image.out
// RUN: %{run} %t_early_image.out
// RUN: %clangxx -fintelfpga -fsycl %t_main.o %t_early_image_sub_x.a %t_early_image_add.a %t_early_image_sub.a %t_early_image_add_x.a -o %t_early_image.out
// RUN: %{run} %t_early_image.out
// RUN: %clangxx -fintelfpga -fsycl %t_main.o %t_early_image_add_x.a %t_early_image_sub_x.a %t_early_image_add.a %t_early_image_sub.a -o %t_early_image.out
// RUN: %{run} %t_early_image.out
// RUN: %clangxx -fintelfpga -fsycl %t_main.o %t_early_image_sub.a %t_early_image_add_x.a %t_early_image_sub_x.a %t_early_image_add.a -o %t_early_image.out
// RUN: %{run} %t_early_image.out

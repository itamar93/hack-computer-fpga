#!/usr/bin/env python3
import argparse
import subprocess
import os
import sys


def main():
    parser = argparse.ArgumentParser(
        description="Automate ModelSim simulation by compiling provided Verilog testbench module name."
    )
    parser.add_argument(
        "--testbench",
        type=str,
        required=True,
        help="Name of the testbench module to simulate (e.g., tb_Mux16)"
    )
    parser.add_argument(
        "--modelsim_exe",
        type=str,
        default=r"C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem\vsim.exe",
        help="Path to the ModelSim vsim.exe executable (default: %(default)s)"
    )
    args = parser.parse_args()

    if not os.path.isfile(args.modelsim_exe):
        print(f"Error: ModelSim executable not found at '{args.modelsim_exe}'")
        sys.exit(1)

    # Use absolute path for source directory
    testbenches_dir = os.path.abspath(os.path.join(os.path.curdir, '..', 'testbenches'))
    verilog_files = []

    print(f"Searching in directory: {testbenches_dir}")
    print(f"Looking for folder: {args.testbench[3:]}")
    for root, folders, files in os.walk(testbenches_dir):
        if os.path.basename(root) == args.testbench[3:]:
            for filename in files:
                if filename.endswith('.v'):
                    # Replace backslashes with forward slashes outside the f-string
                    file_path = os.path.abspath(os.path.join(root, filename))
                    file_path = file_path.replace('\\', '/')
                    verilog_files.append(file_path)

    print(f"Found Verilog files: {verilog_files}")
    if len(verilog_files) == 0:
        print(f"Error: No Verilog files found for module '{args.testbench[3:]}'")
        sys.exit(1)

    # Quote file paths for TCL
    verilog_files_str = " ".join(f'"{f}"' for f in verilog_files)

    # Replace backslashes in the current directory path outside the f-string
    current_dir = os.path.abspath(os.curdir).replace('\\', '/')
    tcl_script_content = f"""\
# Change to the script's directory
cd "{current_dir}"
# Create the work library
vlib work
# Compile the Verilog source files
vlog -work work {verilog_files_str}
# Launch the simulation
vsim work.{args.testbench}
# Run the simulation
run -all
# Exit
quit
"""

    try:
        with open("run_simulation.tcl", "w") as tcl_file:
            tcl_file.write(tcl_script_content)
        print(f"TCL script written to 'run_simulation.tcl'")
    except IOError as e:
        print(f"Error writing TCL file: {e}")
        sys.exit(1)

    cmd = f'"{args.modelsim_exe}" -c -do run_simulation.tcl'
    print("Executing command:")
    print(cmd)

    result = subprocess.run(cmd, shell=True)
    if result.returncode != 0:
        print("Error: Simulation did not complete successfully.")
        sys.exit(result.returncode)
    else:
        print("Simulation completed successfully.")


if __name__ == "__main__":
    main()
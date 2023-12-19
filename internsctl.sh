#!/bin/bash

version() {
  echo "Version: v0.1.0"
}

get_cpu_info() {
  echo "$(lscpu)"
}

get_memory_info() {
  echo "$(free)"
}

help_section() {
  echo "Following are the arguments that are supported by the command: "
  echo "       --version                 			Displays the version of the command "  
  echo "       --help         		 			Displays the help section for the command " 
  echo "       cpu getinfo  		 			Get information about cpu of server."
  echo "       memory getinfo          				Get information about memory of server"
  echo "       user create <username>  				Create a new user on the server"
  echo "       user list <optional argument>    		List all the users on the server"
  echo "               Argument: "
  echo "                --sudo-only           			List all the users with sudo permission on the server"
  echo "       file getinfo <optional argument> <file-name>     Get information about a file on the server"
  echo "               Argument:" 
  echo "       		--size, -s                       	Print size"
  echo "       		--permission, -p                 	Print file permission"
  echo "       		--owner, -o                      	Print file owner"
  echo "       		--last-modified, -m               	Print last modified time"

}

if [ -z "$1" ]; then
  echo "No arguments provided. Command is exiting..."
  exit 0
fi

if [ $1 == "--version" ]; then
  version
elif [ $1 == "cpu" ]; then
  if [ "$2" == "getinfo" ]; then
    get_cpu_info
   else
    echo "Invalid option provided for cpu command."
    exit 1
  fi
elif [ $1 == "memory" ]; then
  if [ "$2" == "getinfo" ]; then
    get_memory_info
   else
    echo "Invalid option provided for memory command."
    exit 1
  fi

elif [ $1 == "user" ]; then
  if [ "$2" == "create" ]; then
     sudo adduser "$3"
  elif [ "$2" == "list" ]; then
	  if [ "$3" == "--sudo-only" ]; then
		  getent group sudo  | awk -F: '{print $4}'
	  else
		  getent passwd | awk -F: '{ print $1}'
	  fi 
  else
    echo "Invalid option provided for user command."
    exit 1
  fi


elif [ "$1" == "file" ] && [ "$2" == "getinfo" ]; then
	  fileOutput=$(ls -l $4)

	  if [ $3 == "--size" -o $3 == "-s" ]; then 
		  echo $fileOutput | awk '{print $5}'
		  exit
	  elif [ $3 == "--permission" -o $3 == "-p" ]; then
		  echo $fileOutput | awk '{print $1}'
		  exit
	  elif [ $3 == "--owner" -o $3 == "-o" ]; then
		  echo $fileOutput | awk '{print $3}'
		  exit
		  
	  elif [ $3 == "--last-modified" -o $3 == "-m" ]; then
		  echo $fileOutput | awk '{print $6 " " $7 " " $8}'
		  exit
	  else
		fileOutput=$(ls -l $3)
	  	echo "File: $3"
		echo "Access: $(echo $fileOutput | awk '{print $1}')"
		echo "Size(B): $(echo $fileOutput | awk '{print $5}')"
		echo "Owner: $(echo $fileOutput | awk '{print $3}')"
		echo "Modify: $(echo $fileOutput | awk '{print $6 " " $7 " " $8}')"
	  	exit
	  fi

elif [ $1 == "--help" ]; then
  help_section  
else
  echo "Invalid option provided"
  help_section
  exit 1
 fi
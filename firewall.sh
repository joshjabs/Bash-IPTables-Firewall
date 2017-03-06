#!/bin/bash
#A Firewall IPTable Wrapper in bash

status()
 {
  opt_status=1
 while [ $opt_status != 7 ]
      do
       clear
  echo -e "\n\tSave Iptables before you Stop/Restart the IPTables Services\n"
  echo -e "   1. Save the iptables - not yet implemented\n
   2. IPTables Status\n
   3. Enable IPTables Services\n
   4. Disable IPTables Services\n
   5. Restart IPTable Services\n
   6. Flush IPTables (This will remove all the rules from iptables)\n
   7. View Current Policy Chain Configuration\n
   8. Generate an HTML Report\n
   9. Go back to Main Menu\n"
 echo -n "Command: "

  read opt_status
  case $opt_status in
    1) iptables save
      echo -e "Press Enter key to Continue..."
      read temp;;
    2) ufw status
      echo -e "Press Enter key to Continue..."
      read temp;;
    3) ufw enable
      echo -e "Press Enter key to Continue..."
      read temp;;

    4) ufw disable
      echo -e "Press Enter key to Continue..."
      read temp;;

    5) ufw reload
       echo -e "Press Enter key to Continue..."
       read temp;;

    6) iptables -F
        echo -e "All the Rules from the Iptables are Flushed!!!"
        echo -e "Press Enter key to Continue..."
        read temp;;
    7) iptables -L
        echo -e "Press Enter key to Continue..."
        read temp;;
    8) iptables -L > $HOME/Desktop/report.html
        sed 's/$/<br>/' $HOME/Desktop/report.html > $HOME/Desktop/iptable-report.html
        rm $HOME/Desktop/report.html
        echo -e "Press Enter key to Continue..."
        read temp;;

    9) main;;
    *) echo -e "Bad choice..."
  esac
 done
 }


buildTheFireWall()
 {
  echo -e "What Chain of Filter Table Are You Implementing?\n
  1. INPUT \n\t This chain is used to control the behavior for incoming connections. For example, if a user attempts to SSH into your PC/server, iptables will attempt to match the IP address and port to a rule in the input chain.\n\n
  2. OUTPUT \n\t This chain is used for outgoing connections. For example, if you try to ping howtogeek.com, iptables will check its output chain to see what the rules are regarding ping and howtogeek.com before making a decision to allow or deny the connection attempt.\n\n
  3. FORWARD \n\t This chain is used for incoming connections that aren’t actually being delivered locally. Think of a router – data is always being sent to it but rarely actually destined for the router itself; the data is just forwarded to its target. Unless you’re doing some kind of routing, NATing, or something else on your system that requires forwarding, you won’t even use this chain.\n\n"
  echo -n "Chain: "
  read opt_ch
  case $opt_ch in
   1) chain="INPUT" ;;
   2) chain="OUTPUT" ;;
   3) chain="FORWARD" ;;
   *) echo -e "Bad choice!"
      main;;
  esac

  echo -e " Specify the source of the packets to be filtered\n\n
  1. Firewall Single Source IP\n
  2. Firewall Source Subnet - A range of IPs\n
  3. Firewall All Source Networks\n"
  echo -n "Using: "

  read opt_ip

  case $opt_ip in
     1) echo -e "\n Enter the IP Address of the Source"
        read ip_source ;;
     2) echo -e "\nEnter the Source Subnet (e.g 192.168.10.0/24)"
        read ip_source ;;
     3) ip_source="0/0" ;;
     *) echo -e "Bad choice"
        main;;
  esac

   echo -e " Specify the destination of the packets to be filtered\n\n
   1. Firewall using Single Destination IP\n
   2. Firewall using Destination Subnet\n
   3. Firewall using for All Destination Networks\n"
   echo -n "Using: "
   read opt_ip
   case $opt_ip in
        1) echo -e "\nPlease Enter the IP Address of the Destination"
            read ip_dest ;;
        2) echo -e "\nPlease Enter the Destination Subnet (e.g 192.168.10.0/24)"
            read ip_dest ;;
        3) ip_dest="0/0" ;;
        *) echo -e "Bad choice"
          main;;
    esac

    echo -e " Specficy the protocol of the packets to be filtered\n\n
       1. Block All Traffic of TCP
       2. Block Specific TCP Service
       3. Block Specific Port
       4. Using no Protocol\n"
       echo -n "Option: "

       read proto_ch
       case $proto_ch in
        1) proto=TCP ;;
        2) echo -e "Enter the TCP Service Name: (CAPITAL LETTERS!!!)"
      read proto ;;
        3) echo -e "Enter the Port Name: (CAPITAL LETTERS!!!)"
       read proto ;;
        4) proto="NULL" ;;
        *) echo -e "Bad choice!"
          main;;
       esac

       echo -e "What should we do with these filtered packets?\n\n
       1. Accept Packet
       2. Reject Packet
       3. Drop Packet
       4. Create Log"
       read rule_ch
       case $rule_ch in
        1) rule="ACCEPT" ;;
        2) rule="REJECT" ;;
        3) rule="DROP" ;;
        4) rule="LOG" ;;
       esac


#Create rule
echo -e "\n\tPress Enter to generate the IPTables Command\n"
read temp
echo -e "The Generated Rule is \n"
if [ $proto == "NULL" ]; then
 echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -j $rule\n"
 gen=1
else
 echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule\n"
 gen=2
fi
echo -e "\n\tAdd this rule to IPTABLES? 1)Yes , 2)No"
read yesno
if [ $yesno == 1 ] && [ $gen == 1 ]; then
 iptables -A $chain -s $ip_source -d $ip_dest -j $rule
else if [ $yesno == 1 ] && [ $gen == 2 ]; then
 iptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule

else if [ $yesno == 2 ]; then

 main
fi
fi
fi
}

main()
{
 ROOT_UID=0
 if [ $UID == $ROOT_UID ];
 then
 clear
 opt_main=1
 while [ $opt_main != 4 ]
 do
 echo -e "\n\tMENU:\n
 1. Check if IPTables Installed\n
 2. Install IPTables\n
 3. Iptables Services\n
 4. Build Your Firewall with Iptables\n
 5. Exit\n"
 echo -n "Command: "
 read opt_main

 printf "\033c"


 case $opt_main in
  1) iptables --version ;;
  2) sudo apt-get install iptables;;
  3) status ;;
  4) buildTheFireWall ;;
  5) exit 0 ;;
  *) echo -e "Bad Choice."
 esac
done
else
 echo -e "Must be ROOT"
fi
}
main
exit 0

# A Bash Firewall IPTables Wrapper
https://github.com/joshjabs/Bash-IPTables-Firewall

This is a little bash script to generate, modify, and view IPTable rules. It can also export an HTML report of the current rules to the Desktop, offers menu item descriptions for clarification, and utilizes UFW to receive active status information. To run, you must execute as root:

>sudo ./firewall.sh

This will open up the main menu which allows you to:

1. Check if IPTables Installed
2. Install IPTables
3. Iptables Services
4. Build Your Firewall with Iptables


Under the IPTables Services, you can:
 1. Save the iptables - not yet implemented
 2. IPTables Status
 3. Enable IPTables Services
 4. Disable IPTables Services
 5. Restart IPTable Services
 6. Flush IPTables (This will remove all the rules from iptables)
 7. View Current Policy Chain Configuration
 8. Generate an HTML Report
 9. Go back to Main Menu

And if you choose to Build Your Firewall with Iptables the script will give you a walk-through to generate the command to manipulate/filter packets. You can specify the chain, source, destination, protocol, and actions to be taken. This will generate an IPTables command which you can import into your active rules.

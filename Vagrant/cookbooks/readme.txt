All cookbooks except the ownCloud one are written by other communities and 
installed using knife.

The following 3rdparty recipes are installed: apache2, nginx, mysql, 
postgresql, apt, git, php, users. All other cookbooks have been pulled as a 
dependency.

I installed the cookbooks the following way:
(1) create a temporary folder outside of the git repository
(2) copy solo.rb to that folder
(3) create a folder called "cookbooks" including a .gitkeep file
(4) git init
(5) git add .
(6) git commit -m "first commit"
(7..n-2) knife cookbook site install $name -c solo.rb
(n-1) copy the cookbooks to the owncloud repository
(n) delete the temporary folder

I (jakobsack) am pretty sure that this is not the way it's meant to be but it
works for me. If you have more experience with knife and chef-solo feel free
to improve this small howto.

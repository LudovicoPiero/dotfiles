let
  ludovico = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHKPBn388QwATBB2GiXYirTYZ+Nd2GTbzaUryyuWi3A ludovicopiero@pm.me";
  sforza = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDS0uDbDRMgd7EVxisAI4y22adKL+KglE21/6p9isrkBXpq6JqE47XYmb4dJ4CL1/RntKW3H7hdVu4Tq+AfzZX4d3QwJQqT1s/iqkOV9PtFzuNoTkND32lV477C11u3d0vqAS1KfPjJeHO/miS5YJGArLMzKA7JgXzRPWp8jjr26rR8TcZ0jWfrU5mq1dG5+KJLvg5iecHxeluWIkS2YqPt0ob5LIcXgaTmD3yIyHWl8Av81+nZeGwlqeotQaO05aggxoI8eKCusqlT5omAo4hW8IGc6ODge7U1coVtIJ2g9TyPYap/wO6PtD0jZYt4CC/e4CI+ObWR6SpK4uYAky049/oKWcKekNbYCBpOzznaKr8hFRkJ+Jjk1bc0NdkZKzL7AzKAFzwOjcmxfbjLtw7g0raGdrTVwrWQeGyfivK908w5xZ7m5GVeyGXMB9/z6H10op5abgv0OTtIVwFyU/fNTo0nFk7LaUGydbPFxCy9PruXtSyKxHj7A+XmxV1+Ivc= ludovico@sforza";

  users = [ludovico];
  hosts = [sforza];
in {
  "userPassword.age".publicKeys = users ++ hosts;
  "rootPassword.age".publicKeys = users ++ hosts;
}

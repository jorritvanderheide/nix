let
  framework = "ssh-rsa ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTl85Z4yCznWRzkKwT+SmTPRByZyL7P+h3/hapaqP9N root@framework";
  # hosts = [framework];

  jorrit = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRKO869CD/GX/yWG/dJuQSdENRPFlcbt65BsX+4wmknppoSJW3HGc+aj23JJ6IDZ4KmMSJsBvHKw8NS+nPuQ4sfnfzLY4l5DhCQlQW7ASZ4tJKejyAghxh9pcbQ6FTydzdwXy5E469SgYiy+YQ3sTr/sP2ih84dZdsxjHMsuQwnN26iShJINagvaa9hdNQdubVomAvyI4HErMyN0XH0fLj9UVm3GDoDSa0XQBWk4cLtbSpDjx0PqWEfqPv1haAGd4SOXVi4118D3DSGHniTD2U62VG94xZe47pl1IDTNQCtFJYP7UEDzXEk00xYbrm1CsxLDr/gxY8W+xoYWH/WRdKukguDpJ3hbSQtejDNJUUDqFU4yWhNPyJu/qv6+dFm0PBi0C5BrperbEhZNjYUlHYKtgDSvoIs1EV2ajKR54si8ptzZWtzC5k6E6PZXw1Hy5LO7jR0Te5BP4tWIr5VNWaTQ5AHHt99v+BlNyC4y6bLSmDgET8VsNZMqMt2e3rZJM= jorrit@framework";
  # users = [jorrit];
in {
  # Login secrets
  "jorrit.age".publicKeys = [jorrit framework];
}

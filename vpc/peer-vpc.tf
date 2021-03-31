resource "aws_vpc_peering_connection" "management_app" {
  peer_owner_id = aws_vpc.app_vpc.owner_id
  peer_vpc_id   = aws_vpc.app_vpc.id
  vpc_id        = aws_vpc.management_vpc.id
  auto_accept   = true

   accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "VPC Peering between Management and app"
  }
}


resource "aws_route" "requestor" {
  route_table_id            = aws_route_table.management_public_rt.id
  destination_cidr_block    = aws_vpc.app_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.management_app.id
  depends_on                = [aws_route_table.management_public_rt, aws_vpc_peering_connection.management_app]
}
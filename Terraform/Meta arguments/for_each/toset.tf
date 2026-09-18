resource "aws_iam_user" "myuser" {
    for_each = toset(["Jack", "James", "Madhu", "Dave"])
    name = each.key
}
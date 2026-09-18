resource "aws_s3_bucket" "myS3bucket" {
    for_each = {
        dev = "dev-bucket"
        qa = "qa-bucket"
        uat = "uat-bucket"
    }

    bucket = "${each.key}-${each.value}"
    # acl = private 

    tags = {
        Environment = "${each.key}"
        bucketname = "${each.key}-${each.value}"
        eachvalue = each.value
    }
}
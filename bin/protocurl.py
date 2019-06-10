from google.protobuf import text_format


from cStringIO import StringIO
from libmproxy.protocol.http import decoded
import re
def response(context, flow):

    if flow.response.headers.get_first("content-type", "").startswith('application/x-protobuf'):
      with decoded(flow.response):
         data=flow.response.content
         data2=re.sub('"http://.*?"','"http://some other url"' ,data)
         flow.response.content=data2

However when the client receive the file it throw "Failed to 


# f = open('a.txt', 'r')
# address_book = addressbook_pb2.AddressBook() # replace with your own message
# text_format.Parse(f.read(), address_book)
# f.close()

# write to a text file

# f = open('b.txt', 'w')
# f.write(text_format.MessageToString(address_book))
# f.close()

# The c++ equivalent is:

# bool ReadProtoFromTextFile(const std::string filename, google::protobuf::Message* proto)
# {
#     int fd = _open(filename.c_str(), O_RDONLY);
#     if (fd == -1)
#         return false;

#     google::protobuf::io::FileInputStream* input = new google::protobuf::io::FileInputStream(fd);
#     bool success = google::protobuf::TextFormat::Parse(input, proto);

#     delete input;
#     _close(fd);
#     return success;
# }

# bool WriteProtoToTextFile(const google::protobuf::Message& proto, const std::string filename)
# {
#     int fd = _open(filename.c_str(), O_WRONLY | O_CREAT | O_TRUNC, 0644);
#     if (fd == -1)
#         return false;

#     google::protobuf::io::FileOutputStream* output = new google::protobuf::io::FileOutputStream(fd);
#     bool success = google::protobuf::TextFormat::Print(proto, output);

#     delete output;
#     _close(fd);
#     return success;
# }

   // The sailing unique identifier.
    types.UUID sailing_id = 1;

    // Encapsulates the start and end date of the sailing.
    //
    // start is the date on which the sailing embarks from its first port.
    // end is the date on which the sailing disembarks at its final port.
    types.DateRange date_range = 2;

    // The ship unique identifier that this sailing belongs.
    types.UUID ship_id = 3;

    // The ship name that this sailing belongs.
    //
    // This field is here for convenience, it's redundant
    // in the sense that it's the `ship_id` the identifier
    // of the master data.
    google.protobuf.StringValue ship_name = 4;

    // TODO: document this
    google.protobuf.StringValue season_code = 5;

    // TODO: document this
    google.protobuf.StringValue destination_code = 6;

    // TODO: document this
    google.protobuf.BoolValue active = 7;

    // TODO: document this
    google.protobuf.StringValue group_code = 8;

    // TODO: document this
    google.protobuf.BoolValue is_charter = 9;

    // This is a place holder to put free attributes
    // like legacy ids.
    //
    // Name convention for keys is out of the scope of this
    // message and should be defined elsewhere.
    map<string, string> attributes = 10;
}

#include "types.h"
#include "mp3.h"
#include "vector.h"
#include "csv.h"
#include "html.h"
#include "xml.h"

status_t status;

status_t (*pExport[]) (ADT_Array_t *, string) = {
   Export2CSV,
   Export2HTML,
   Export2XML
};

status_t (*MP3_printer[]) (ADT_MP3_t *, FILE *) = {
   Print_CSV,
   Print_HTML,
   Print_XML
};

export_t export_id;

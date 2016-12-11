vcl 4.0;

backend default {
  .host = "0.0.0.0";
  .port = "80";
  .first_byte_timeout = 600s;
}

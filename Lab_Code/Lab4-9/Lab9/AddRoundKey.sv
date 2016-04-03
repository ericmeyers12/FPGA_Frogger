module AddRoundKey(input logic [0:127] in, key,
                   output logic [0:127] out);
assign out = {
                 in[0:7] ^ key[0:7], in[8:15] ^ key[8:15], in[16:23] ^ key[16:23], in[24:31] ^ key[24:31],
                 in[32:39] ^ key[32:39], in[40:47] ^ key[40:47], in[48:55] ^ key[48:55], in[56:63] ^ key[56:63],
                 in[64:71] ^ key[64:71], in[72:79] ^ key[72:79], in[80:87] ^ key[80:87], in[88:95] ^ key[88:95],
                 in[96:103] ^ key[96:103], in[104:111] ^ key[104:111], in[112:119] ^ key[112:119], in[120:127] ^ key[120:127]
                 };
endmodule
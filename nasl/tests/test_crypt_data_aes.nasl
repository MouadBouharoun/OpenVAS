# Copyright (C) 2022 Greenbone Networks GmbH
#
# SPDX-License-Identifier: GPL-2.0-or-later
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

key = raw_string(0xa9, 0x87, 0xf5, 0x2b, 0xaf, 0x99, 0x06, 0xfa, 0x04, 0x8e, 0x2d, 0xb4, 0x6f, 0x50, 0x88, 0xa3); # Encryption Key

nonce = raw_string(0x49, 0xa9, 0xe3, 0x12, 0x4d, 0xb5, 0x69, 0xeb, 0xef, 0x13, 0x4f, 0x2f); # Nonce 11 Bytes

aad = raw_string(0x49, 0xa9, 0xe3, 0x12, 0x4d, 0xb5, 0x69, 0xeb,
				 0xef, 0x13, 0x4f, 0x2f, 0x00, 0x00, 0x00, 0x00,
				 0x6e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,
				 0x4d, 0x00, 0x00, 0x78, 0x55, 0x18, 0x00, 0x00);

data = raw_string(0xfe, 0x53, 0x4d, 0x42, 0x40, 0x00, 0x01, 0x00,
				  0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x81, 0x1f, 
				  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
				  0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
				  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
				  0x4d, 0x00, 0x00, 0x78, 0x55, 0x18, 0x00, 0x00, 
				  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
				  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
				  0x09, 0x00, 0x00, 0x00, 0x48, 0x00, 0x26, 0x00, 
				  0x5c, 0x00, 0x5c, 0x00, 0x31, 0x00, 0x39, 0x00, 
				  0x32, 0x00, 0x2e, 0x00, 0x31, 0x00, 0x36, 0x00, 
				  0x38, 0x00, 0x2e, 0x00, 0x39, 0x00, 0x2e, 0x00, 
				  0x37, 0x00, 0x30, 0x00, 0x5c, 0x00, 0x49, 0x00, 
				  0x50, 0x00, 0x43, 0x00, 0x24, 0x00 );

crypt = aes128_gcm_encrypt_auth ( key:key,iv:nonce, data:data, aad:aad );
encrypt = crypt[0];
signature = crypt[1];

testcase_start("test_aes128_gcm encrypt signature");
if(hexstr(signature) == "5fa4ed441e482bf586e0f07be7eefc28") {
  testcase_ok();
} else {
  testcase_failed();
	display("Wrong signature: " + hexstr(signature));
}

testcase_start("test_aes128_gcm encrypt");
if(hexstr(encrypt) == "95dfb1325902969990096fc398a3c25334"+
	"94db23544a282d5549926a055f0400c1d09f4a493c51fa24a3b26"+
	"7bcf06ad6d38f89d582d181098aeccaf02e7495685bc563cbeb66" +
	"7af90d820adc5db0b705effc03078c57741ad954a3726ab08af1d0eac3ff4f0f442cffb7203aa4ce"){
  testcase_ok();
} else {
  testcase_failed();
	display("False data: " + hexstr(encrypt));
}

crypt = aes128_gcm_decrypt_auth (key:key, iv:nonce, data:encrypt, len: strlen(data), aad:aad);

decrypt = crypt[0];
tag = crypt[1];

testcase_start("test_aes128_gcm decrypt");
if (decrypt == data) {
  testcase_ok();
} else {
  testcase_failed();
}

testcase_start("test_aes128_gcm decrypt tag");
if (hexstr(tag) == "5fa4ed441e482bf586e0f07be7eefc28") {
  testcase_ok();
} else {
  testcase_failed();
}

# SPDX-FileCopyrightText: 2023 Greenbone AG
# Some text descriptions might be excerpted from (a) referenced
# source(s), and are Copyright (C) by the respective right holder(s).
#
# SPDX-License-Identifier: GPL-2.0-or-later

# OpenVAS Testsuite for the NASL interpreter
# Description: Test routine for checksum computations.

function checkmd(name, expected, value)
{
  local_var hexval;

  testcase_start(name);

  hexval = hexstr(value);
  if (hexval == expected)
    {
      testcase_ok();
    }
  else
    {
      testcase_failed();
      display("expected: ", expected, "\n");
      display("got:      ", hexval, "\n");
    }
}

checkmd(name:"MD4", value:MD4("abc"),
	expected:"a448017aaf21d8525fc10ae87aa6729d");
checkmd(name:"MD5", value:MD5("abc"),
	expected:"900150983cd24fb0d6963f7d28e17f72");
checkmd(name:"SHA1", value:SHA1("abc"),
	expected:"a9993e364706816aba3e25717850c26c9cd0d89d");
checkmd(name:"RIPEMD160", value:RIPEMD160("abc"),
	expected:"8eb208f7e05d987a9b044a8e98c6b087f15a0bfc");

checkmd(name:"HMAC_MD5", value:HMAC_MD5(data:"abc", key:"xyz"),
	expected:"36507bde4caa8241226bb568596d3439");
checkmd(name:"HMAC_SHA1", value:HMAC_SHA1(data:"abc", key:"xyz"),
	expected:"a2b2e8c7de17e4f249b9539b4e56f18e4735f0c9");
checkmd(name:"HMAC_RIPEMD160", value:HMAC_RIPEMD160(data:"abc", key:"xyz"),
	expected:"25b990841b02514cacc090a9979857b33a69735f");

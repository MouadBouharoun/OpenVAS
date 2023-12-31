/* SPDX-FileCopyrightText: 2023 Greenbone AG
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

/**
 * @file nasl_smb.h
 * @brief Protos for NASL SMB API
 *
 * This file contains the protos for \ref nasl_smb.c
 */

#ifndef NASL_NASL_SMB_H
#define NASL_NASL_SMB_H

/* for lex_ctxt */
#include "nasl_lex_ctxt.h"

/* for tree_cell */
#include "nasl_tree.h"

tree_cell *
nasl_smb_versioninfo (lex_ctxt *lexic);
tree_cell *
nasl_smb_connect (lex_ctxt *lexic);
tree_cell *
nasl_smb_close (lex_ctxt *lexic);
tree_cell *
nasl_smb_file_SDDL (lex_ctxt *lexic);
tree_cell *
nasl_smb_file_owner_sid (lex_ctxt *lexic);
tree_cell *
nasl_smb_file_group_sid (lex_ctxt *lexic);
tree_cell *
nasl_smb_file_trustee_rights (lex_ctxt *lexic);
tree_cell *
nasl_win_cmd_exec (lex_ctxt *lexic);

#endif

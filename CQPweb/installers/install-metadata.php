<?php
/*
 * CQPweb: a user-friendly interface to the IMS Corpus Query Processor
 * Copyright (C) 2008-today Andrew Hardie and contributors
 *
 * See http://cwb.sourceforge.net/cqpweb.php
 *
 * This file is part of CQPweb.
 * 
 * CQPweb is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * CQPweb is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @file
 * 
 * Run 
 *         php install-corpus.php --help 
 * 
 * ... for info about this script. 
 */
		
$longopts = [
		'help', 
		'version',
		'corpus:',
		'metadataFile:',
		'metadataTemplateId:',
		'runFullSetup'
];	

$opt_array = getopt('hvHVf:', $longopts);

if (empty($opt_array))
	$opt_array = array('help' => false);


$_GET = [];


$_GET['createMetadataRunFullSetupAfter'] = 0;


foreach ($opt_array as $opt_key => $opt_val)
{
	switch($opt_key)
	{
		/* odd ones */
		
	case 'h':
	case 'H':
	case 'help':
		echo cli_print_install_metadata_help();
		exit;
	
	case 'v':
	case 'V':
	case 'version':
		echo cli_print_install_metadata_version();
		exit;
				
		/* strings */
		
	case 'corpus':
		/* corpus is a form parameter, but it's ignored */
		$_GET['c'] = $opt_val;
		break;
	case 'metadataFile':
		$_GET['dataFile'] = $opt_val;
		break;
	case 'metadataTemplateId':
		$_GET['useMetadataTemplate'] = $opt_val;
		break;
	case 'runFullSetup':
		$_GET['createMetadataRunFullSetupAfter'] = 1;
		break;
	default:
		exit("\nERROR: unrecognised option $opt_key! \n\n");
	}
}

$_GET['mdAction'] = 'createMetadataFromFile';

if (!isset($_SERVER))
	$_SERVER = [];
$_SERVER['QUERY_STRING'] = 'metadata-act.php?' . http_build_query($_GET); 

error_log($_SERVER['QUERY_STRING']);	
unset($files, $req, $opt_array, $opt_key, $opt_val, $longopts);


require ('../lib/metadata-act.php');


/* 
 * END OF SCRIPT
 */




function cli_print_install_metadata_help()
{
	return <<<END_OF_HELP

====================================
CQPWEB METADATA INSTALLATION UTILITY
====================================

Install a metadata tempate into a CQPweb corpus

Usage: 
   php install-metadata.php [options]
      (** from /path/to/cqpweb/bin **)

Arguments that are not options or values of options are ignored. 

Note that this script requires a metadata template to have been created on the
system at https://cqpw-prod.vip.sydney.edu.au/CQPweb/adm/index.php?ui=metadataTemplates

General options:
================

* -h, --help
  Print this help message and exit.

* -v, --version
  Print the version message and exit.

* --corpus
  The handle of the corpus for which the metadata is being installed

* --metadataFile
  The metadata file relative to the uploads/ directory

* --metadataTemplateId
  The ID number of the metadata template

* --runFullSetup
  Will build frequency tables after installing the metadata

END_OF_HELP;

}
	

function cli_print_install_corpus_version_version()
{
	return <<<END_OF_INFO

This is a hack to get metadata installed from the command line, v 0.0.1

END_OF_INFO;
	
	
	
}



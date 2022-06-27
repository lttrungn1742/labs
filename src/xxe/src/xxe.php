<?php

function docx2text($filename) {
    return readZippedXML($filename, "word/document.xml");
}

function readZippedXML($archiveFile, $dataFile) {
// Create new ZIP archive
    $zip = new ZipArchive;
    
    // Open received archive file
    if (true === $zip->open($archiveFile)) {
        // If done, search for the data file in the archive
        if (($index = $zip->locateName($dataFile)) !== false) {
            // If found, read it to the string
            $data = $zip->getFromIndex($index);
            // Close archive file
            $zip->close();
            // Load XML from a string
            // Skip errors and warnings
            $xml = new DOMDocument();
            $xml->loadXML($data, LIBXML_NOENT | LIBXML_XINCLUDE | LIBXML_NOERROR | LIBXML_NOWARNING);
            // Return data without XML formatting tags
            return strip_tags($xml->saveXML());
        }
        $zip->close();
    }
    
    // In case of failure return empty string
    return "";
}




$target_dir = "uploads/";
$target_file = $target_dir . basename($_FILES["file"]["name"]);
$uploadOk = 1;
$imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));


// Check file size
if ($_FILES["file"]["size"] > 500000) {
  echo  "Sorry, your file is too large.";
  $uploadOk = 0;
}

// Allow certain file formats
if($imageFileType != "docx"  ) {
    echo  "Sorry, only docx file is allowed.";
  $uploadOk = 0;
}

// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    echo  "Sorry, your file was not uploaded.";
// if everything is ok, try to upload file
} else {
  if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {

    echo  htmlentities(docx2text("uploads/".basename( $_FILES["file"]["name"])));
  } else {

    echo "Sorry, there was an error uploading your file.";
  }
}
?>
#! /bin/sh
#  revised 2020-10-16 11:47 AM	
#  revised 2021-05-09 12:47 PM Changed the READ statements to CASE syntext to solve -n option error.
DIR=/home/emarshall/pCloudDrive
SOURCE_EMAIL=/$DIR/Gen/Email/OutgoingEMail.txt

PREAMBLE ()
	{
		echo "EHLO RockSoildPE" > /$DIR/Gen/Email/tempEMAIL.txt
		echo "AUTH LOGIN" >> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Um9ja1NvbGlkUEU=" >> /$DIR/Gen/Email/tempEMAIL.txt
		echo "YmFybmV5RnJlZCV3aWxtYTc0" >> /$DIR/Gen/Email/tempEMAIL.txt
		echo "MAIL FROM: e.marshall@ewmpe.com" >> /$DIR/Gen/Email/tempEMAIL.txt
	}

PREDATA ()
	{
		grep "^RCPT TO:" < $SOURCE_EMAIL >> /$DIR/Gen/Email/tempEMAIL.txt
	}

TO_FROM_SUBJECT ()
	{
		echo "DATA" 							>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "X-List: EWMSENT"						>> /$DIR/Gen/Email/tempEMAIL.txt
		grep "^To:" < $SOURCE_EMAIL 					>> /$DIR/Gen/Email/tempEMAIL.txt
		grep "^Cc:" < $SOURCE_EMAIL 					>> /$DIR/Gen/Email/tempEMAIL.txt
		grep "^From:" < $SOURCE_EMAIL 					>> /$DIR/Gen/Email/tempEMAIL.txt
		grep "^Subject:" < $SOURCE_EMAIL 				>> /$DIR/Gen/Email/tempEMAIL.txt
	}

TO_FROM_SUBJECT_REVIEW ()
	{
		echo "--------------------------------------------------------------"
		echo "--------------------------------------------------------------"
		grep "^RCPT TO:" < $SOURCE_EMAIL 					
		grep "^To:" < $SOURCE_EMAIL 					
		grep "^Cc:" < $SOURCE_EMAIL 				
		grep "^From:" < $SOURCE_EMAIL 			
		grep "^Subject:" < $SOURCE_EMAIL 	
		grep "^:Attachment:" < $SOURCE_EMAIL 	
		echo "--------------------------------------------------------------"
		echo "--------------------------------------------------------------"
	}

BoundaryHeader_1 ()
	{
		BOUNDARY_BASIC="54321BOUNDARYoooBOUNDARDYoooBOUNDARY12345"	
		echo "Content-Type: multipart/mixed;" 				>> /$DIR/Gen/Email/tempEMAIL.txt
		echo " boundary=\"b1_${BOUNDARY_BASIC}\"" 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "MIME-Version: 1.0"		 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
	}


BoundaryHeader_2 ()
	{
		echo "--b1_${BOUNDARY_BASIC}" 					>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Type: multipart/alternative;" 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo " boundary=\"b2_${BOUNDARY_BASIC}\"" 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
	}


BoundaryHeader_3 ()
	{
		echo "--b2_${BOUNDARY_BASIC}"		 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Type: text/plain; charset=utf-8" 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Transfer-Encoding: base64" 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
	}


BoundaryHeader_4 ()
	{
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "--b2_${BOUNDARY_BASIC}" 					>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Type: text/html; charset=utf-8" 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Transfer-Encoding: base64" 			>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
	}


BoundaryHeader_5 ()
	{
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 							>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "--b1_${BOUNDARY_BASIC}"		 					>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Type: $CONTENTTYPE; name=\"$ATTACHMENT_1_FILENAME\"" 		>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Transfer-Encoding: base64" 					>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "Content-Disposition:attachment; filename=\"$ATTACHMENT_1_FILENAME\""	>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 									>> /$DIR/Gen/Email/tempEMAIL.txt
	}


BoundaryTail_1 ()
	{
		echo "" 								>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 								>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "--b2_${BOUNDARY_BASIC}--" 					>> /$DIR/Gen/Email/tempEMAIL.txt
	}


BoundaryTail_2 ()
	{
		echo "" 								>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "" 								>> /$DIR/Gen/Email/tempEMAIL.txt
		echo "--b1_${BOUNDARY_BASIC}--" 					>> /$DIR/Gen/Email/tempEMAIL.txt
	}


TEXT_2_base64 ()
	{
		echo "E.W. Marshall, PE" 										> /$DIR/Gen/Email/temp2
		echo "18100 Nassau Bay Drive #5, Houston, TX 77058   ***  (619) 916-3268 --- e.marshall@ewmpe.com"	>> /$DIR/Gen/Email/temp2
		echo "=================================================================================" 		>> /$DIR/Gen/Email/temp2
		sed '/QUIT/Q' $SOURCE_EMAIL  										> /$DIR/Gen/Email/temp1 
		sed -n '/^:Attachment:/ { :a; n; p; ba; }' /$DIR/Gen/Email/temp1 					>> /$DIR/Gen/Email/temp2
		base64 -w 80 /$DIR/Gen/Email/temp2 									> /$DIR/Gen/Email/TextBase64.txt
	}


HTML_2_base64 ()
	{
		echo "<p style=\"color: blue; line-height: 90%; font-size: 16pt;\">EW Marshall PE</p>"		> /$DIR/Gen/Email/temp3
		echo "<p style=\"color: black; line-height: 90%; font-size: 14pt;\">18100 Nassau Bay Drive <sup>#</sup>5, Houston, TX 77058</p>   "	>> /$DIR/Gen/Email/temp3
		echo "<p style=\"color: black; line-height: 90%; font-size: 13pt;\">\(619\) 916-3268, e.marshall@ewmpe.com</p>   "	>> /$DIR/Gen/Email/temp3
		echo " " 								>> /$DIR/Gen/Email/temp3
		echo " * * * * * * * * * * * * * * * * * *   " 								>> /$DIR/Gen/Email/temp3
		echo " " 								>> /$DIR/Gen/Email/temp3
		sed '/QUIT/Q' $SOURCE_EMAIL  										>  /$DIR/Gen/Email/temp1 
		sed -n '/^:Attachment:/ { :a; n; p; ba; }' /$DIR/Gen/Email/temp1 					>> /$DIR/Gen/Email/temp3
		pandoc -f markdown -t html5 -o - /$DIR/Gen/Email/temp3 -c style.css 					> /$DIR/Gen/Email/temp2
 		base64 -w 80 /$DIR/Gen/Email/temp2 									>  /$DIR/Gen/Email/HTMLBase64.txt

	}


FILE_2_base64 ()
	{
		base64 -w 80 "`grep  :Attachment: < $SOURCE_EMAIL | cut -c 14-400`" 				> /$DIR/Gen/Email/FILEBase64.txt
	}

FileType ()
	{
	#### Evaluate attachment type. Either png, pdf, or zip. Then set the correct MIME header information

	ATTACHMENT_1_FILENAME=`grep  :Attachment: < $SOURCE_EMAIL | cut -c 14-400 | sed 's#\(^.*/\)\(.*$\)#\2#g'`

		case "$ATTACHMENT_1_FILENAME" in
		    *jpg )
				 CONTENTTYPE=image/jpeg
			;;
		    *pdf )
				 CONTENTTYPE=application/pdf
			;;
		    *png )
				 CONTENTTYPE=image/png
			;;
		    *tif )
				 CONTENTTYPE=image/tiff
			;;
		    *zip )
				 CONTENTTYPE=application/zip
			;;
		    * )
				 CONTENTTYPE=NOATTACH
			;;
		esac

		echo ""
		echo ""
		echo "-----------------"
echo "--- --- --- --- --- Attachment evaluated is $ATTACHMENT_1_FILENAME."
	}		


EMAILEND ()
{
				echo "" >> /$DIR/Gen/Email/tempEMAIL.txt
				echo "." >> /$DIR/Gen/Email/tempEMAIL.txt
				echo "" >> /$DIR/Gen/Email/tempEMAIL.txt
				echo "QUIT" >> /$DIR/Gen/Email/tempEMAIL.txt
				echo "" >> /$DIR/Gen/Email/tempEMAIL.txt
}

# ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===   ===    ===   ===   
#	
#	888888b.                     d8b          
#	888  "88b                    Y8P          
#	888  .88P                                 
#	8888888K.   .d88b.   .d88b.  888 88888b.  
#	888  "Y88b d8P  Y8b d88P"88b 888 888 "88b 
#	888    888 88888888 888  888 888 888  888 
#	888   d88P Y8b.     Y88b 888 888 888  888 
#	8888888P"   "Y8888   "Y88888 888 888  888 
#	                         888              
#	                    Y8b d88P              
#	                     "Y88P"               
#	
# ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===  ===    ===   ===   ===    ===   ===   
#
#	Preliminaries that need to go first
		TEXT_2_base64 
		HTML_2_base64 
		FILE_2_base64 
		FileType

#Show recipients
		TO_FROM_SUBJECT_REVIEW
		echo ""
		echo ""
		echo "----------------------------------------------------------"
while true; do
	read -r -p "       Basics look good? (Y/N): " answer
    case $answer in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

# Show an HTML preview of the email to be sent first
		cp /$DIR/Gen/Email/temp2 /$DIR/Gen/Email/temp2.html 
		/usr/bin/elinks /$DIR/Gen/Email/temp2.html 
		# less /$DIR/Gen/Email/temp2 
		echo ""
		echo ""
		echo "----------------------------------------------------------"

while true; do
	read -r -p "       Send this email? (Y/N): " answer
    case $answer in
        [Yy]* ) break;;
        [Nn]* ) exit; echo -e "\t\tEmail cancelled.\n\n";;
        * ) echo "Please answer Y or N.";;
    esac
done
    		# Send the email

		PREAMBLE
		PREDATA
		TO_FROM_SUBJECT
		BoundaryHeader_1
		BoundaryHeader_2
		BoundaryHeader_3
			cat /$DIR/Gen/Email/TextBase64.txt		>> /$DIR/Gen/Email/tempEMAIL.txt
		BoundaryHeader_4
			cat /$DIR/Gen/Email/HTMLBase64.txt		>> /$DIR/Gen/Email/tempEMAIL.txt
		BoundaryTail_1
	#### Insert attachment unless attachment equals NONE, or none, or ...

		if [ $CONTENTTYPE != "NOATTACH" ]; then
			#### Add then the attachment header
		BoundaryHeader_5
			cat /$DIR/Gen/Email/FILEBase64.txt		>> /$DIR/Gen/Email/tempEMAIL.txt
		fi
		BoundaryTail_2

	#### Send sign-off
		EMAILEND

	#### Send
	cat /$DIR/Gen/Email/tempEMAIL.txt | openssl s_client -crlf -quiet -starttls smtp -connect  smtp.ultrasmtp.com:587

	#### Save a copy of the sent email

	echo Timestamp --- `date` >> /$DIR/Gen/Email/Log-2021Email.txt
	sed '/^:::/d' $SOURCE_EMAIL | sed '/^.$/d' | sed '/^QUIT/d' | sed '/^DATA/d' >> /$DIR/Gen/Email/Log-2021Email.txt


/* Create a cas session called 'mysess' with 30 mins timeout */
cas mysess sessopts=(caslib=casuser timeout=1800 locale="en_US" metrics=True);

/* Shows notes, warnings, and errors,plus informational messages
that can help you understand more about SAS's internal processing
(e.g., index usage, optimizer decisions, etc.)
*/
options msglevel=i;

/* Load and replace 'sashelp.cars' to 'casuser.mycars' etc. */
proc casutil;
  droptable incaslib=casuser casdata="MYcaRs" quiet;
  load data=sashelp.cars outcaslib="casuser" casout="mycars" replace;
quit;


/* ---------- Working with Array ---------- */
/* Create an array of integer */
proc cas;
  myarray={10, 20, 30, 40};
  do i = 1 to dim(myarray);
    print "Item #" i||': '||myarray[i];
  end;
quit;

/* Create an array of strings */
proc cas;
  myarray={"Apple", "Orange", "Persimmon"};
  do i = 1 to dim(myarray);
    print "Item #" i||': '||myarray[i];
  end;
quit;

/* Create an array mixing numeric, strings and arrays */
proc cas;
  myarray={"Apple", 1, "Orange", 2, "Persimmon", 3};
  nested_array={{1,2,3},{'A','B','C',{'Eric','Aaron'}},{1,'A',2,'B',3,'C'}};
  print "The entire array: " myarray;
  print "The entire array (nested): " nested_array;
  do i = 1 to dim(myArray);
    print "Item #" i||': '||myarray[i];
  end;

  print "1: " myarray[2:4]; /* Elements from 2 to 4 */
  print "2: " myarray[{2,4,6}]; /* Elements 2, 4 and 6 */
  print "3: " nested_array[1]; /* 1st element */
  print "4: " nested_array[3]; /* 3rd element */
  print "5: " nested_array[2][1]; /* 1st element nested in the 2nd element */
  print "6: " nested_array[2][4][2]; /* Obtaining 'Aaron' */
quit;

/* Array of dictionaries */
proc cas;
  d1 = {name="John", age=30};
  d2 = {name="Jane", age=28};
  describe d1;
  describe d2;
  people = {d1, d2};
  print people[1]['name']; /* 'John' */
  print people[2]['age']; /* 28 */
quit;

/* Array operations */
/* Append one array to another */
/* CASL arrays are immutable in size, so you always create a new
   array as a workaround if you need to remove elements from it.
*/
proc cas;
  array1={1,2,3};
  array2={'A','B','C'};
  print "Append Array into Another: " array1||array2;
quit;

/* Insert an element into array */
proc cas;
  array1={1,2,3};
  print "Insert an element: " array1||4;
quit;

/* Check difference and common values */
proc cas;
  array1={1,2,3,4,5};
  array2={3,4,5,6,7};
  print "Difference 1: " array1 - array2; /* from array1 */
  print "Difference 2: " array2 - array1; /* from array2 */
  print "Common: " array1 & array2; /* common for both */
quit;

/* Check if an element is in an array */
proc cas;
  array1={1,2,3,4,5};
  if 5 in array1 then
    print "Yes, 5 is included";
  else
    print "No, 5 is not included";
quit;

/* Some functions for array */
/* dim() */
proc cas;
  array1={1,2,3};
  array2={'A','B','C','D','E'};
  print "Array 1 Dimension: " dim(array1);
  print "Array 2 Dimension: " dim(array2);
quit;

/* range() */
proc cas;
  array1={1,2,3,4,5};
  print "Difference between Max-Min: " range(array1);
quit;

/* missing() */
proc cas;
  array1 = {100, ., 300, ., 500};
  do i = 1 to dim(array1);
    if missing(array1[i]) then
      print "Missing value at index: " i;
    else
      print "Value at index " i ": " array1[i];
  end;
quit;

/* sort */
proc cas;
  array1={5,3,1,4,2};
  array2={'D','A','C','E','B'};
  print "Array 1 sort: " sort(array1);
  print "Array 1 reverse sort: " sort_rev(array1);
  print "Array 2 sort: " sort(array2);
  print "Array 2 reverse sort: " sort_rev(array2);
quit;


/* ---------- Working with Dictionary ---------- */

/* Create a dictionary */
proc cas;
  person={{name='Amy', sex='F', age=30, height=68.5, weight=89.5},
          {name='Bob', sex='M', age=35, height=72.0, weight=180.2},
          {name='Cindy', sex='F', age=28, height=65.0, weight=10.0}
         };
  describe person;
  print person;
quit;

/* Looping through dictionary */
proc cas;
  person={{name='Amy', sex='F', age=30, height=68.5, weight=89.5},
          {name='Bob', sex='M', age=35, height=72.0, weight=180.2},
          {name='Cindy', sex='F', age=28, height=65.0, weight=10.0}
         };
  /* Accessing using bracket notation */
  do i = 1 to dim(person);
    print "Name: " person[i]['name'] ", Sex: " person[i]['sex']
          ",Age: " person[i]['age'];
  end;
  print " ";
  /* Accesing using dot notation */
  do i = 1 to dim(person);
    print "Name: " person[i].name ", Sex: " person[i].sex
          ",Age: " person[i].age;
  end;
quit;

/* Looping through dictionary - another approach */
proc cas;
  person={{name='Amy', sex='F', age=30, height=68.5, weight=89.5},
          {name='Bob', sex='M', age=35, height=72.0, weight=180.2},
          {name='Cindy', sex='F', age=28, height=65.0, weight=10.0}
         };
  /* Get the key:value pair */
  do key, value over person;
    print key ": " value;
  end;
  print " ";
  /* Print each record for each person */
  do key, value over person;
    do k, v over value;
	  print k " " v;
	end;
	print " ";
  end;
quit;

/* Simple example of using dictionary for CAS action */
proc cas;
  /* Using a dictionary to specify caslib and table */
  mytable={caslib="casuser",name="mycars"};
  table.tableinfo / caslib=mytable.caslib;
  table.columninfo / table=mytable;
  table.fetch result=myres / table=mytable, to=7;
  describe myres;
  print myres.Fetch; /* Note, 'Fetch' is the key */
quit;

/* Simple example of using dictionary for CAS action and
resulting dictionary from fetch.
*/
proc cas;
  mytable={caslib="casuser", name="mycars", where="Make='Toyota'"};
  mycolnames={"Make", "Model", "Type", "Cylinders", "MSRP"};
  simple.numRows result=myres /
        table=mytable;
  table.fetch /
       table=mytable,
       fetchVars=mycolnames,
       sortBy={{name="MSRP",order="DESCENDING"}
               },
       to=myres.numrows;
  /* Check what column are available for simple.numrows */
  describe myres;
  print "Total rows returned    : " myres.numrows;
  print dim(myres);
quit;



/* ---------- Cleaning existing CAS tables / library ---------- */

/* Delete any leftover tables */
proc casutil;
  droptable incaslib=casuser casdata="MYcaRs" quiet;
run;

/* Obtaining Table/file level info */
proc cas;
 mylib="casuser";
 table.tableInfo / caslib=mylib; /* CAS Table info */
 table.fileInfo / caslib=mylib; /* filesystem level info */
quit;


/* Terminate the current CAS session called 'mysess' */
cas mysess terminate;
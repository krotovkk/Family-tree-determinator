main :-
    open('file.ged', read, Str),
    read_file(Str,Lines),
    close(Str),
    open('mytree2.pl', write, Stream), 
    getsex(Lines, Stream),
    childproc(Lines,Lines,Stream),
    close(Stream).


read_file(Stream,[]) :-
    at_end_of_stream(Stream).


read_file(Stream,[Y|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream,Codes),
    atom_chars(X, Codes),
    atomic_list_concat(Y,' ',X),
    read_file(Stream,L), !.

getsex([],_).
getsex([[_,'NAME',X|_],_,_,[_,_,'F']|T2], Stream):- 
    writeq(Stream,female(X)),write(Stream, .),nl(Stream), getsex(T2, Stream).
getsex([[_,'NAME',X|_],_,_,[_,'SEX','M']|T2], Stream):- 
    writeq(Stream,male(X)),write(Stream, .), nl(Stream), getsex(T2, Stream).
getsex([[_|_]|T],Stream):- getsex(T,Stream).

childproc([],_,_).
childproc([[_,'HUSB',ParentID|_],[_,_,WifeID],[_,'CHIL',ChildID]|T],MainList,Stream):-
    findperson(MainList,ParentID,Par),
    findperson(MainList,ChildID,Chi),
    findperson(MainList,WifeID,Wif),
    writeq(Stream,child(Chi,Par)),write(Stream, .),nl(Stream), writeq(Stream,child(Chi,Wif)),write(Stream, .), nl(Stream),
    hasanotherchild(T,Par,Wif,MainList,Stream),childproc(T,MainList,Stream).
    
childproc([[_|_]|T],MainList,Stream):-childproc(T,MainList,Stream).
    
findperson([[_,PersonID,'INDI'],_,[_,'NAME',Person|_]|_],PersonID,Person):-!.
findperson([[_|_]|T],PersonID,Person):-findperson(T,PersonID,Person).

hasanotherchild([[_|_]|T],_):-!.
hasanotherchild([[_,'CHIL',ChildID]|T],Man,Wife,MainList,Stream):-
    findperson(MainList,ChildID,Chi),
    writeq(Stream,child(Chi,Man)),write(Stream, .),nl(Stream), writeq(Stream,child(Chi,Wife)),write(Stream, .), nl(Stream),
    hasanotherchild(T,Man,Wife,MainList,Stream),!.

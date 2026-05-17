module ComplaintManagement

// USERS
abstract sig User {}
sig Customer extends User {}
sig SupportAgent extends User {}
sig Admin extends User {}

// STATUS
abstract sig Status {}
one sig Open, Assigned, InProgress, Resolved, Closed extends Status {}

// NOTES
sig Note {}

// TICKET
sig Ticket {
    ticketID: one Int,
    status: one Status,
    assignedTo: lone SupportAgent,
    resolutionNotes: lone Note
}

//Constraints
fact UniqueTicketIDs {
    all disj t1, t2: Ticket |
        t1.ticketID != t2.ticketID
}

fact ClosedTicketsCannotBeAssigned {
    all t: Ticket |
        t.status = Closed implies no t.assignedTo
}

fact ResolvedTicketsNeedNotes {
    all t: Ticket |
        t.status = Resolved implies some t.resolutionNotes
}

//Assertion
assert NoDuplicateIDs {
    all disj t1, t2: Ticket |
        t1.ticketID != t2.ticketID
}

assert ClosedTicketNoAgent {
    all t: Ticket |
        t.status = Closed implies no t.assignedTo
}

//check 
check NoDuplicateIDs for 5

check ClosedTicketNoAgent for 5

run {} for 5


//Counter example 
assert WrongRule {
    all t: Ticket |
        t.status = Closed implies some t.assignedTo
}

check WrongRule for 5




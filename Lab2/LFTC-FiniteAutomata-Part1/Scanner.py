from  Transition import Transition
class Scanner:
    def __init__(self,filename):
        self.states = []
        self.alphabet = []
        self.initialState = ""
        self.finalStates = []
        self.transitions = []
        self.readFiniteAutomata(filename)

    def readFiniteAutomata(self,filename):
        f = open(filename,"r")
        for line in f:
            if line[0] == "Q":
                states = line[2:].strip().split(",")
                for state in states:
                    self.states.append(state)
            if line[0] == "A":
                alphabet = line[2:].strip().split(",")
                for alpha in alphabet:
                    self.alphabet.append(alpha)
            if line[0] == "I":
                initialState = line[2:].strip()
                if initialState not in self.states:
                    print("Initial state not valid!!!")
                    return
                self.initialState=initialState
            if line[0] == "F":
                finalStates = line[2:].strip().split(",")
                for finalState in finalStates:
                    if finalState not in self.states:
                        print("Final state not valid!!!")
                        return
                for finalState in finalStates:
                    self.finalStates.append(finalState)

            if line[0] == "T":
                transitions = line[2:].strip().split(";")
                for transtion in transitions:
                    #print(transtion)
                    start = transtion[0:2]
                    if start not in self.states:
                        print("Invalid start for transition")
                        return
                    end = transtion[3:5]
                    if end not in self.states:
                        print("Invalid end for transition")
                        return
                    rule = transtion[6]
                    if rule not in self.alphabet:
                        print("Invalid rule for transition")
                        return
                    t = Transition(start,end,rule)
                    self.transitions.append(t)

    def displayElements(self):
        print("---States---")
        for i in self.states:
            print(i, end=" ")
        print("\n---Initial state---")
        print(self.initialState)
        print("---Final states---")
        for state in self.finalStates:
            print(state, end=" ")
        print("\n---Alphabet---")
        for alpha in self.alphabet:
            print(alpha, end=" ")
        print("\n---Transitions---")
        for trans in self.transitions:
            print(trans)



    """
        The method returns the destination it can be reached from a starting point with a transition.
        If there is no destination, it returns an empty list
    """

    def isRoad(self,start,rule):
        listEnd = []
        for trans in self.transitions:
            #print("------->",trans)
            if trans.start == start:
                #print("11111",trans)
                if trans.rule == rule:
                    #print("22222",trans)
                    listEnd.append(trans.destination)
        return listEnd

    """
        The method checks if a sequence is valid or not and if it's not valid it returns the longest prefix accepted.
        Starting from the initialState, it checks if there is any road using the first letter of the sequence
        If there is, the letter is added to a list which keeps all the letters from the sequence until we can't find a road anymore
        If the last state found by the sequence is not a finalState, it means that the last added letter from the sequence is not part of the valid prefix
    """

    def checkSequence(self,sequence):
        print("sequence: ",sequence)
        longestSequence = []
        alldest =[]
        dest = self.isRoad(self.initialState,sequence[0])
        alldest.append(dest[0])
        if dest != []:
            longestSequence.append(sequence[0])
            j = 1;
            while j < len(sequence):
                dest = self.isRoad(dest[0],sequence[j])
                if dest != []:
                    longestSequence.append(sequence[j])
                    alldest.append(dest[0])
                    j = j + 1
                else:
                    if alldest[len(alldest)-1] not in self.finalStates:
                            return longestSequence[:-1]
                    else:
                        return longestSequence
        if dest == [] or dest[0] not in self.finalStates:
            return longestSequence

        return sequence


    def longestSequence(self,initialseq,seq2):
        if seq2 == initialseq:
            print("Accepted!")

        else:
            print("Invalid sequence")
            print("Longest accepted prefix of the sequence is:")
            print(seq2)




if __name__=="__main__":
    """
    scanner = Scanner("finite_automata.txt")
    scanner.displayElements()
    print("----------")
    scanner.checkSequence("65452848")
    print("----------")
    scanner.checkSequence("-312781347")
    print("----------")
    scanner.checkSequence("41g213")
    print("----------")
    scanner.checkSequence("52379")
    print("----------")
    scanner.checkSequence("-3")
    print("----------")
    scanner.checkSequence("a424324")
    """
    scanner = Scanner("input.txt")
    scanner.displayElements()
    print("----------")
    scanner.longestSequence("010",scanner.checkSequence("010"))
    print("----------")
    scanner.longestSequence("01011",scanner.checkSequence("01011"))
    print("----------")
    scanner.longestSequence("01000",scanner.checkSequence("01000"))

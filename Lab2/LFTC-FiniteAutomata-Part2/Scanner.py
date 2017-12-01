import re

from sortedcontainers import SortedDict

from FiniteAutomata import FiniteAutomata


class Scanner:
    def __init__(self):
        self.__description = "program1.txt"
        self.__table = "handMadeInternalTable.txt"
        self.__pifTable = "programInternalForm.txt"
        self.__symTableFile = "symbolTable.txt"
        self.__inputTable = {}
        self.__symTable = SortedDict()
        self.readHandMadeTable()


    def getDescription(self):
        return self.__description

    def getFileTable(self):
        return self.__table

    def getSymTable(self):
        return self.__symTable

    def getInputTable(self):
        return self.__inputTable

    def readHandMadeTable(self):
        index = 1
        f = open(self.__table, "r")
        for line in f:
            self.__inputTable[line.strip()]=index
            index += 1
        f.close()

    def createPif(self):
        f = open(self.__description,"r")
        g = open(self.__pifTable, "w")
        h = open(self.__symTableFile, "w")
        constantAutomata  = FiniteAutomata("constantAutomata.txt")
        identifierAutomata = FiniteAutomata("identifierAutomata.txt")
        symbolAutomata = FiniteAutomata("symbolAutomata.txt")
        index = 100
        lines = []
        for line in f:
            lines.append(line)
        word = ""
        for line in lines:
            print("line:",line)
            for char in line:
                if word == "" and char == " ":
                   pass
                else:
                    word += char

                if(word!=" " and word[:-1]!="" and word!=""):
                    print("####" + word + "####")
                    if word[:-1] == symbolAutomata.checkSequence(word):
                        print("syyyyyyyyymm")
                        if word[:-1] in self.__inputTable:
                            print("---------", word[:-1])
                            g.write(str(self.__inputTable[word[:-1]]) + " | -\n")
                        if (word[-1:] != " "):
                            word = word[-1:]
                        else:
                            word = ""

                    elif word[:-1] == identifierAutomata.checkSequence(word):
                        print("!!!!", word)
                        if(word [:-1] in self.__inputTable):
                            g.write(str(self.__inputTable[word[:-1]]) + " | -\n")
                        else:
                                if (word[:-1] not in self.__symTable):
                                    print("sym "+ word[:-1])
                                    self.__symTable[word[:-1]] = index
                                    index += 1
                                g.write("500" + " | " + str(self.__symTable[word[:-1]]) + "\n")

                        if(word[-1:]!= " "):
                            word=word[-1:]
                        else:
                            word=""

                    elif word[:-1] == constantAutomata.checkSequence(word):
                        print("const: ", word)
                        if (word[:-1] not in self.__symTable):
                            self.__symTable[word[:-1]] = index
                            g.write("300" + " | " + str(self.__symTable[word[:-1]]) + "\n")
                        index += 1
                        if (word[-1:] != " "):
                            word = word[-1:]
                        else:
                            word = ""
            word = ""
        for k, v in self.__symTable.items():
            h.write(str(k) + " | "+ str(v) + "\n");
        f.close()


if __name__ == "__main__":
    s = Scanner()
    s.createPif()
    #dict = s.getSymTable()
    #print(dict)

from sortedcontainers import SortedDict
import re

class Scanner:
    def __init__(self):
        self.__description = "program1.txt"
        self.__table = "handMadeInternalTable.txt"
        self.__pifTable = "programInternalForm.txt"
        self.__symTableFile = "symbolTable.txt"
        self.__inputTable = {}
        self.__parsedProgram = []
        self.__symTable = SortedDict()
        self.readDescription()
        self.readHandMadeTable()

    def getDescription(self):
        return self.__description

    def getFileTable(self):
        return self.__table

    def getParsedProgram(self):
        return self.__parsedProgram

    def getInputTable(self):
        return self.__inputTable

    def readHandMadeTable(self):
        index = 1;
        f = open(self.__table, "r")
        for line in f:
            self.__inputTable[line.strip()]=index
            index += 1
        f.close()

    def readDescription(self):
        f = open(self.__description,"r")
        for line in f:
            wordslist = re.compile("('[^']*')|\t|\n| |(\\+)|(-)|(%)|(\\*)|(\\/)|(==)|(<=)|(>=)|(!=)|(=)|(\\!)|(<<)|(>>)|(>\\?)|(<)|(>)|(\\?)|(\\[)|(])|(\\()|(\\))|(:)|(;)|(,)|(\\.)").split(line)
            #print(wordslist)
            for word in wordslist:
                if word != None and word !="":
                    #print("-----"+word+"------")
                    self.__parsedProgram.append(word)
        f.close()

    def createPif(self):
        f = open(self.__pifTable,"w")
        g = open(self.__symTableFile, "w")
        index = 100
        for word in self.__parsedProgram:
            if word not in self.__inputTable:
                if word not in self.__symTable:
                    try:
                        if self.validate(word):
                            self.__symTable[word] = index
                            index += 1
                    except Exception as e:
                        print(e)
                        return


        #self.__symTable = collections.OrderedDict(sorted(self.__symTable.items()))
        for k, v in self.__symTable.items():
            g.write(str(k) + " | "+ str(v) + "\n");


        for word in self.__parsedProgram:
                if word in self.__inputTable:
                    f.write(str(self.__inputTable[word]) + " | -\n")
                elif word  in self.__symTable:
                    if word.isdigit():
                        f.write("300" + " | " + str(self.__symTable[word])  +"\n")
                    else:
                        f.write("500" + " | " + str(self.__symTable[word])  +"\n")


        f.close()
        g.close()


    def validate(self,word):
        if len(word) >8 :
            raise Exception("Error! Identifier '" + word + "' is too long!!")

        if word.isalpha():
            return True

        if word.isdigit():
            return True

        if not word[0].isalpha():
            raise Exception("Error!" +  word)



        for letter in word:
            if not letter.isalpha():
                if not letter.isdigit():
                    raise Exception("Error!" +  word)

        return True


if __name__ == "__main__":
    s = Scanner()
    dict = s.getInputTable()
    #print(dict)
    s.createPif()

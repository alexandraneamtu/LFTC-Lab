class Transition:
    def __init__(self, start, destination, rule):
        self.start = start
        self.destination = destination
        self.rule = rule

    def __repr__(self):
        return self.start + " -> " + self.rule + " -> " +self.destination
from random import randint

print(randint(0, 10))

password = "secret"

a = eval("""
    3 + 2 \
    + randint(0, 10)

""")
assert a

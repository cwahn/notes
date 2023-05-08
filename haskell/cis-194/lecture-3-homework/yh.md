FSM  
Finite State Machine

- Input set: $I$
  - Initial state
- Output set: $O$
- State set: $S$
- Update function: $(I, S) \rarr S$
- Output function: $(I, S) \rarr O$

input : 0 1
state : 0 1
output: 0 1 

--- 

Function 
- name
- parameter 
- body

```
add2 (x: int) -> int
    x + 1

add2 :: int -> int 

y = add2(2)
y = 3

f :: a -> b
g :: b -> c 

h :: a -> c
h = g(f(x))

function_1 (x: int) -> int
    a + x 

a = 1
y = function_1 (2)

a = 2
y = function_1 (2)

get_i() -> int
    ... 


print_i(x: int) -> ()
print(s: string) -> ()

x = get_i()
y = x + 1
print_i(y)

x = get_i()
y = x + 1
()

fsm :: I -> O (x)
fsm :: (I, S) -> (O, S)

update :: (I, S) -> S
ouput :: (I, S) -> O

react :: (I, S) -> (O, S)
react i s = {
    new_s = update(i, s)
    (output(i, new_s), new_s)
}

referential transp. : 참조툼ㅅ
    함수의 호출문을 그 결과로 바꿔써도 문제가 없음
    = 수학적인 함수임
    = 결과가 입력에만 의존함

```
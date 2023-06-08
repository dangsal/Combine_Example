import UIKit
import Combine


// Just로 publusher 생성, sink, receivedCompletion 사용
let publisher = Just("dangsal").sink { result in
    switch result {
    case .finished:
        print("finished")
    case .failure(let error):
        print(error.localizedDescription)
    }
} receiveValue: { value in
    print(value)
}
// Future로 publisher 생성
print("------------------------------1-------------------------------------")
// -----------------------------------------------------------------------------------------
class DangsalSubscriber: Subscriber {
    typealias Input = String
    
    typealias Failure = Never
    
    // subscriber에게 publisher 를 성공적으로 구독했음을 알리고 item을 요청 할 수 있음
    func receive(subscription: Subscription) {
        print("구독 시작")
        subscription.request(.max(1))
    }
    // subsriber에게 publisher 가 element를 생성했음을 알림
    func receive(_ input: String) -> Subscribers.Demand {
        print("\(input)")
        return .max(1)
    }
    // subscriber에게 publisher가 정상적으로 또는 오류로 publish를 완료했음을 알림
    func receive(completion: Subscribers.Completion<Never>) {
        print("완료", completion)
    }
}

let name = Just("Lee Sung Ho")
name.subscribe(DangsalSubscriber())

print("-----------------------------------2------------------------------------")


let names = ["hoya", "ginger", "chemi", "mary", "id"].publisher
names.print().subscribe(DangsalSubscriber())

print("----------------------------------3-------------------------------------")

names.print().sink { print($0) }

print("----------------------------------4-------------------------------------")

class IntSubscriber: Subscriber {
    typealias Input = Int
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    func receive(_ input: Int) -> Subscribers.Demand {
        print(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        
    }
    
}

let intArray: [Int] = [1, 2, 3, 4, 5]

intArray.publisher
    .subscribe(IntSubscriber())

print("----------------------------------Just-------------------------------------")

let just = Just("This is Output")
just
    .sink { completion in
        print("received completion: \(completion)")
    } receiveValue: { value in
        print("received value: \(value)")
    }

print("----------------------------------Future-------------------------------------")

var subscriptions = Set<AnyCancellable>()
var emitValue: Int = 0
var delay: TimeInterval = 3

func createFuture() -> Future<Int, Never> {
    return Future<Int, Never> { promise in
        delay -= 1
        print("\(delay)")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            emitValue += 1
            promise(.success(emitValue))
        }
    }
}

let firstFuture = createFuture()
let secondFuture = createFuture()
let thirdFuture = createFuture()

//firstFuture
//    .sink(receiveCompletion: { print("첫번째 Future Completion: \($0)") },
//          receiveValue: { print("첫번째 Future value: \($0)") })
//    .store(in: &subscriptions)
//
//secondFuture
//    .sink(receiveCompletion: { print("두번째 Future completion: \($0)") },
//          receiveValue: { print("두번째 Future value: \($0)") })
//    .store(in: &subscriptions)
//
//thirdFuture
//    .sink(receiveCompletion: { print("세번째 Future completion: \($0)") },
//          receiveValue: { print("세번째 Future value: \($0)") })
//    .store(in: &subscriptions)
//
//thirdFuture
//    .sink(receiveCompletion: { print("세번째 Future completion2: \($0)") },
//          receiveValue: { print("세번째 Future value2: \($0)") })
//    .store(in: &subscriptions)



print("----------------------------------AnyPublisher-------------------------------------")

let originalPublisher = [1, nil , 3].publisher

let anyPublisher = originalPublisher.eraseToAnyPublisher()
anyPublisher.sink { value in
    print(value)
}

print("----------------------------------Empty-------------------------------------")

let empty = Empty<String, Never>()
empty
    .sink {
        print("completion: \($0)")
    } receiveValue: { value in
        print(value)
    }
print("-")
let anyPublisher1 = [1, nil , 3].publisher
    .flatMap { value -> AnyPublisher<Int, Never> in
        if let value = value {
            return Just(value).eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }.eraseToAnyPublisher()


anyPublisher1.sink(receiveCompletion: { print("AnyPublisher completion: \($0)") },
                  receiveValue: { print("value : \($0)") }
)


print("----------------------------------Example-------------------------------------")

var myIntArrayPublisher: Publishers.Sequence<[Int], Never> = [1, 2, 3].publisher

myIntArrayPublisher.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("완료")
    case .failure(let error):
        print("실패 \(error.localizedDescription)")
    }
}, receiveValue: { value in
    print("값: \(value)")
})

print("---------------")
var myNotification = Notification.Name("com.combine.notification")
var myDefaultPublisher: NotificationCenter.Publisher = NotificationCenter.default.publisher(for: myNotification)

var mySubscription: AnyCancellable?

var mySubscriptionSet = Set<AnyCancellable>()

mySubscription = myDefaultPublisher.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("완료")
    case .failure(let error):
        print("실패 \(error.localizedDescription)")
    }
}, receiveValue: { value in
    print("값: \(value)")
})

mySubscription?.store(in: &mySubscriptionSet)

NotificationCenter.default.post(Notification(name: myNotification))

mySubscription?.cancel()

class MyFriend {
    var name = "철수" {
        didSet {
            print("name이 바겼다 \(name)")
        }
    }
}
var myFriend = MyFriend()
var myFriendSubscription: AnyCancellable = ["영수"].publisher.assign(to: \.name, on: myFriend)

print("--------------- AnyCancellable --------------------")

let subject = PassthroughSubject<Int, Never>()
let anyCancellable = subject
    .sink(receiveCompletion: { completion in
        print("completion: \(completion)")
    }, receiveValue: { value in
        print("value: \(value)")
    })

subject.send(1)
anyCancellable.cancel()
subject.send(2)

let anyCancellable2 = subject
    .handleEvents(
        receiveCancel: {
            print("cancel 불렀음")
        })
    .sink(receiveCompletion: { completion in
        print("completion: \(completion)")
    }, receiveValue: { value in
        print("value: \(value)")
    })
subject.send(5)
anyCancellable2.cancel()

print("--------------- Just --------------------")

let just1 = Just([1, 2, 3])
just1
    .sink(receiveCompletion: { _ in
        print("just 완료")
    }, receiveValue: { value in
        print(value)
    })

print("--------------- Future --------------------")

func createFuture1() -> Future<Int, Never> {
    return Future<Int, Never> { promise in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            promise(.success(52))
        })
    }
}

//let future1 = createFuture1()
//    .sink(receiveCompletion: { completion in
//            print("완료 \(completion)")
//    }, receiveValue: { value in
//        print("Future: \(value)")
//    })

print("----------------------------------Deferred-------------------------------------")

struct DeferredPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        subscriber.receive("Deferred Publisher 여기야")
        subscriber.receive(completion: .finished)
    }
}

let deferred = Deferred {
    print("deferredPublisher 가 만들어짐\n")
    return DeferredPublisher()
}

deferred
    .sink {
        print($0)
    } receiveValue: {
        print($0)
    }


print("----------------------------------CurrentValueSubject-------------------------------------")

let currentValueSubject = CurrentValueSubject<String, Never>("Dangsal 의 첫번째 값")

currentValueSubject
    .sink(receiveCompletion: { print("1 번째 sink completion: \($0)") },
          receiveValue: { print("1 번째 sink value: \($0)") } )

currentValueSubject
    .sink(receiveCompletion: { print("2 번째 sink completion: \($0)") },
          receiveValue: { print("2 번째 sink value: \($0)") })

currentValueSubject
    .sink(receiveCompletion: { print("3 번째 sink completion: \($0)") },
          receiveValue: { print("3 번째 sink value: \($0)") })


currentValueSubject.send("Dangsal 의 두번째 값")
currentValueSubject.send(completion: .finished)

print(currentValueSubject.value)

print("----------------------------------sink-------------------------------------")

let intArrayPublisher = [1, 2, 3, 4, 5].publisher

let sink = Subscribers.Sink<Int, Never>(receiveCompletion: { print("completion: \($0)") },
                                        receiveValue: { print("value: \($0)") })
intArrayPublisher.subscribe(sink)

intArrayPublisher
    .sink(receiveCompletion: { print("completion: \($0)") },
          receiveValue: { print("value: \($0)") } )

print("----------------------------------sink cancel -------------------------------------")



print("----------------------assgin-----------------------------------------")

class SampleObject {
    var intValue: Int {
        didSet {
            print("intValue Changed: \(intValue)")
        }
    }
    
    init(intValue: Int) {
        self.intValue = intValue
    }
    
    deinit {
        print("sample object deinit")
    }
}

let myObject = SampleObject(intValue: 5)

let assgin = Subscribers.Assign<SampleObject, Int>(object: myObject, keyPath: \.intValue)

let intArrayPublisher4 = [6, 6, 1, 2].publisher
intArrayPublisher4.subscribe(assgin)
print(myObject.intValue)
print("----------------------assgin Operator-----------------------------------------")

let intArrayPublisher5 = [1, 2, 3, 4 ,6].publisher
    .assign(to: \.intValue, on: myObject)

print(myObject.intValue)

print("-------------------------Demand------------------------")

class DemandTestSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        print("subscribe 시작!")
        // 여기서 Demand를 설정해줄 수도 있어요!
        // 현재 요청횟수는 1
        subscription.request(.max(1))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("receive input: \(input)")
        
        // input 값이 2일때만 요청횟수를 1 추가합니다.
        if input == 2 {
            return .max(1)
        } else {
            return .none
        }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("receive completion: \(completion)")
    }
}

let publisher13 = [2, 3, 4, 5].publisher
publisher13
    .print()
    .subscribe(DemandTestSubscriber())

print("------------------- cancel() ----------------------")

var subscription = Set<AnyCancellable>()

let stringArray: [String] = ["dang", "sal"]

stringArray.publisher
    .sink(receiveValue: { print($0) } )
    .store(in: &subscription)

print("------------------- map ----------------------")

let intPulisherMap = [1, 2 ,3 ,4 ,5 ,6 ,7].publisher

intPulisherMap
    .map { element in
        return element * 2
    }
    .sink(receiveValue: { print($0) })

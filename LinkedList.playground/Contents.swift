import UIKit

class LinkedList<T> {
    var head: LinkedListNode<T>
    
    init?(_ list: T...) {
        guard let head = LinkedList<T>.headNode(with: list) else { return nil }
        self.head = head
    }
    
    init?(_ list: [T]) {
        guard let head = LinkedList<T>.headNode(with: list) else { return nil }
        self.head = head
    }
    
    private static func headNode(with list: [T]) -> LinkedListNode<T>? {
        guard let first = list.first else { return nil }
        let head = LinkedListNode(value: first)
        var currentNode = head
        for i in 1..<list.count {
            let newNode = LinkedListNode(value: list[i], leftNode: currentNode)
            currentNode = newNode
        }
        return head
    }
    
}

class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode<T>?
    
    init(value: T, leftNode: LinkedListNode<T>? = nil) {
        self.value = value
        defer {
            leftNode?.next = self
        }
    }
}


extension LinkedList: CustomStringConvertible {
    
    var description: String {
        var string = "List("
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            string += String(describing: node.value)
            if node.next != nil {
                string += ", "
            }
            currentNode = node.next
        }
        return string + ")"
    }
    
}

//P1
extension LinkedList {
    
    var last: T? {
        var currentNode: LinkedListNode? = head
        while currentNode?.next != nil {
            currentNode = currentNode?.next
        }
        return currentNode?.value
    }
    
}

//P2
extension LinkedList {
    
    var pennultimate: T? {
        var currentNode: LinkedListNode? = head
        while currentNode?.next != nil, currentNode?.next?.next != nil {
            currentNode = currentNode?.next
        }
        return currentNode?.value
    }
    
}

//P3
extension LinkedList {
    
    subscript(index: Int) -> T? {
        guard index >= 0 else { return nil }
        
        var currentIndex = 0
        var currentNode: LinkedListNode<T>? = head
        
        while currentNode != nil {
            if currentIndex == index {
                return currentNode?.value
            }
            currentNode = currentNode?.next
            currentIndex += 1
        }
        
        return nil
    }
    
}

//P4
extension LinkedList {
    
    var length: Int {
        var count = 1
        var currentNode: LinkedListNode<T>? = head
        while currentNode?.next != nil {
            currentNode = currentNode?.next
            count += 1
        }
        return count
    }
    
}

//P5
extension LinkedList {
    
    func reversed() -> LinkedList? {
        var nodes: [LinkedListNode<T>] = []
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            nodes.append(node)
            currentNode = node.next
        }
        return LinkedList(nodes.reversed().map { $0.value })
    }
    
    func reverse() {
        var nodes: [LinkedListNode<T>] = []
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            nodes.append(node)
            currentNode = node.next
        }
        head.next = nil
        for i in (1..<nodes.count).reversed() {
            nodes[i].next = nodes[i - 1]
        }
        head = nodes[nodes.count - 1]
    }
    
}

//P6
extension LinkedList where T: Equatable {
    
    var isPalindrome: Bool {
        guard let reversed = reversed() else { return false }
        var currentNode: LinkedListNode<T>? = head
        var currentReversedNode: LinkedListNode<T>? = reversed.head
        while currentNode != nil, currentReversedNode != nil {
            if currentNode?.value != currentReversedNode?.value {
                return false
            }
            currentNode = currentNode?.next
            currentReversedNode = currentReversedNode?.next
        }
        return true
    }
    
}

//P8
extension LinkedList where T: Equatable {
    
    func compress() {
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            while node.value == node.next?.value {
                node.next = node.next?.next
            }
            currentNode = node.next
        }
    }
    
}

//P9
extension LinkedList where T: Equatable {
    
    var packed: LinkedList<LinkedList<T>>? {
        var newLists: [LinkedList<T>] = []
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            var subListElements: [T] = [node.value]
            var currentSubnode: LinkedListNode<T>? = node
            while let subnode = currentSubnode, subnode.value == subnode.next?.value {
                subListElements.append(subnode.value)
                currentSubnode = subnode.next
            }
            if let newList = LinkedList(subListElements) {
                newLists.append(newList)
            }
            currentNode = currentSubnode?.next
        }
        return LinkedList<LinkedList<T>>(newLists)
    }
    
}

//P10
extension LinkedList where T: Equatable {
    
    var encoded: LinkedList<(Int, T)>? {
        guard let packedList = packed else { return nil }
        var tuples: [(Int, T)] = []
        var currentNode: LinkedListNode<LinkedList<T>>? = packedList.head
        while let node = currentNode {
            tuples.append((node.value.length, node.value.head.value))
            currentNode = currentNode?.next
        }
        return LinkedList<(Int, T)>(tuples)
    }
    
}

//P11
extension LinkedList where T: Equatable {
    
    var encodedWithModification: LinkedList<Any>? {
        guard let packedList = packed else { return nil }
        var elements: [Any] = []
        var currentNode: LinkedListNode<LinkedList<T>>? = packedList.head
        while let node = currentNode {
            let length = node.value.length
            let value = node.value.head.value
            if length > 1 {
                elements.append((length, value))
            } else {
                elements.append(value)
            }
            currentNode = currentNode?.next
        }
        return LinkedList<(Any)>(elements)
    }
    
}

//P12
extension LinkedList {
    
    var decoded: LinkedList<Any>? {
        var elements: [Any] = []
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            guard let tuple = node.value as? (Int, Any) else { return nil }
            elements += [Any](repeating: tuple.1, count: tuple.0)
            currentNode = node.next
        }
        return LinkedList<Any>(elements)
    }
    
}

//P14
extension LinkedList {
    
    func duplicate() {
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            let next = currentNode?.next
            let copy = LinkedListNode(value: node.value, leftNode: node)
            copy.next = next
            currentNode = next
        }
    }
    
}

//P15
extension LinkedList {
    
    func duplicate(_ times: Int) {
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode {
            let next = currentNode?.next
            var parentCopy = node
            for _ in 1..<times {
                let newCopy = LinkedListNode(value: parentCopy.value, leftNode: parentCopy)
                parentCopy = newCopy
            }
            parentCopy.next = next
            currentNode = next
        }
    }
    
}

//P20
extension LinkedList {
    
    func remove(at index: Int) {
        guard index >= 0 else { return }
        
        if index == 0 {
            if let next = head.next {
                head = next
            }
            return
        }
        
        var currentIndex = 0
        var currentNode: LinkedListNode<T>? = head
        while let node = currentNode, currentIndex < index - 1{
            currentNode = node.next
            currentIndex += 1
        }
        if let node = currentNode, currentIndex == index - 1 {
            node.next = node.next?.next
        }
    }
    
}

//P21
extension LinkedList {
    
    func insert(_ element: T, at index: UInt) {
        if index == 0 {
            let newNode = LinkedListNode(value: element)
            newNode.next = head
            head = newNode
            return
        }
        
        var currentNode: LinkedListNode<T>? = head
        var currentIndex: UInt = 0
        
        while currentNode != nil, currentIndex < index - 1 {
            currentNode = currentNode?.next
            currentIndex += 1
        }
        if let targetNode = currentNode, currentIndex == index - 1 {
            let next = targetNode.next
            let newNode = LinkedListNode(value: element, leftNode: targetNode)
            newNode.next = next
            targetNode.next = newNode
        }
    }
    
}

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

let list = LinkedList("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")
list?.compress()
print(list?.description ?? "")

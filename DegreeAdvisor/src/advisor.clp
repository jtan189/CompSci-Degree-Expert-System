;; First define templates for the model classes so we can use them
;; in our pricing rules. This doesn't create any model objects --
;; it just tells Jess to examine the classes and set up templates
;; using their properties

(import com.joshktan.advisor.model.*)
(deftemplate Course       (declare (from-class Course)))
(deftemplate GradedCourse   (declare (from-class GradedCourse)))
(deftemplate LabScienceSequence (declare (from-class LabScienceSequence)))
(deftemplate Record (declare (from-class Record)))
(deftemplate Advice (declare (from-class Advice)))


;; Global variables
(defglobal ?*total-credit-req* = (get-member com.joshktan.advisor.req.TotalCreditsRequirement TOTAL_CREDITS_REQUIRED))

;; University Graduation Requirements

;; Old rule
;; (defrule total-credit-req
;;     "Advise to take more credits if total credit amount is less than the required amount."
;;     ?r <- (Record {totalCredits < ?*total-credit-req*})
;;     =>
;;    (assert (enough-credits))
;;     (add (new Advice "TotalCreditsRequirement" "Too little credits" (str-cat "Have " ?r.totalCredits " credits, but need " ?*total-credit-req* ".") "ISSUE")))

(defrule credit-advice
    "Advise to take more credits if total credit amount is less than the required amount."
    ?r <- (Record)
    =>
    (if (< ?r.totalCredits ?*total-credit-req*) then
    (assert (not-enough-credits))
    else
    (assert (enough-credits))))


(defrule not-enough-credits
    "Advise to take more credits if total credit amount is less than the required amount."
    (not-enough-credits)
    ?r <- (Record)
    =>
    (add (new Advice "TotalCreditsRequirement" "Too little credits" (str-cat "Have " ?r.totalCredits " credits, but need " ?*total-credit-req* ".") "ISSUE")))


;; (# semesters left * 20 ) < (needed - already have) => advise warning: fill out form thing for +20 credits / semester (or summer school or postpone grad)

;; Graduating Honors (figure out how to chain rules: (if all courses have grades) && (all requirements fulfilled) => (add congrats)


;; COULD BE USEFUL:
;; The not CE can be used in arbitrary combination with the and and or CEs. You can define complex logical structures this way. For example, suppose you want a rule to fire once if for every fact (a ?x), there is a fact (b ?x). You could express that as
;; Jess> (defrule forall-example
;;   (not (and (a ?x) (not (b ?x))))
;;   =>)
;; i.e., "It is not true that for some ?x, there is an (a ?x) and no (b ?x)". This is actually how the the forall CE is implemented.

;; note: (instanceof <external-address> <class-name>)

;; COULD ALSO BE USEFUL
;; The logical conditional element lets you specify logical dependencies among facts. All the facts asserted on the RHS of a rule become dependent on the matches to the logical patterns on that rule's LHS. If any of the matches later become invalid, the dependent facts are retracted automatically.
;; (defrule rule-1
;;   (logical (faucet-open))
;;   =>
;;   (assert (water-flowing)))
;;   =>
;;   (assert (all-cour)))



;; Graduation with honor eligibility is determined in two steps:
;; Step One: Earn a minimum NDSU (institutional) GPA of 3.50
;; NDSU GPA's below 3.50 are not considered (and step two is not necessary)
;; Step Two: Earn an overall (cumulative) GPA of 3.50 or greater, which includes:
;; all credits and grades earned at NDSU
;; the inclusion of all transfer work and all attempts of repeated coursework
;;
;; Candidates who achieve an overall GPA of 3.50 or higher according to the criteria listed above will graduate: 
;; Cum Laude — greater than or equal to 3.50 and less than 3.70 
;; Magna Cum Laude — greater than or equal to 3.70 and less than 3.90 
;; Summa Cum Laude — greater than or equal to 3.90 and up to 4.00 
;; The complete Graduation with Honor policy may be reviewed in the online Undergraduate Bulletin
;; PLEASE BE AWARE grade-point averages are NOT rounded (for example, a GPA of 3.497 is not rounded to 3.5) 
;; PLEASE BE AWARE graduation with honor levels are subject to change once final grades are determined and posted to the official academic record

;; ;; matches any
;; (defrule any
;;   (Record (studentId ?sId))
;;   =>
;;   ((System.out) println "Testing 1,2,3" ))

(defrule graduate-with-honors
  ?record <- (Record {gpa >= 3.5})
  (forall ?course <- (Course)
	  (instanceof ?course "GradedCourse"))
  ;; add other requirements here
  =>
   (assert (honors))
;;   ((System.out) println (str-cat "Congrats, dude (" ?record.studentId ")"))
    (if (>= ?record.gpa 3.90) then
      (add (new Congrats "You will graduate summa cum laude."))
;;      ((System.out) println "Summa Cum Laude")
     elif (>= ?record.gpa 3.70) then
;;      ((System.out) println "Magna Cum Laude")
      (add (new Congrats "You will graduate magna cum laude."))
;;      (bind ?msg "Congratulations! You will graduate magna cum laude.")
     else
;;      ((System.out) println "Cum Laude"))
      (add (new Congrats "You will graduate cum laude."))))
;;      (bind ?msg "Congratulations! You will graduate cum laude.")
;;    (add (new Congrats ?msg)))

;; Just so you know how to do it
;; (defrule enough-credits-and-honors
;;   "enough credits and honors also"
;;   (and (honors) (enough-credits))
;;   =>
;;   ((System.out) println "Both enough credits and also honorable!"))
